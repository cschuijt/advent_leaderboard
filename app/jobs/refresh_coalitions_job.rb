class RefreshCoalitionsJob < ApplicationJob
  class  IntraAPIError < StandardError; end
  extend FortytwoIntra

  queue_as :default

  def fortytwo_api_client
    @client ||= FortytwoIntra::APIClient.new(ENV['FORTYTWO_KEY'], ENV['FORTYTWO_SECRET'])
  end

  def perform
    ActiveRecord::Base.transaction do
      # After a certain amount of tries, we want to give up and stop the job
      try = 0

      resp = fortytwo_api_client.get_response('/v2/coalitions')
      while (resp.status != 200 && try < 5) do
        logger.warn "Failed to fetch initial coalition amount, retrying."
        sleep(1)
        resp = fortytwo_api_client.get_response('/v2/coalitions')
        try += 1
      end

      if try == 5 then
        raise IntraAPIError, "tried and failed to fetch coalition count five times"
      end

      total = resp.headers['x-total'].to_i
      i = 1

      logger.info "Fetching #{total} coalition records from 42."

      while ((i - 1) * 100 < total) do
        sleep(2)
        logger.info "Fetching and updating page #{i} of coalitions"
        resp = fortytwo_api_client.get_response('/v2/coalitions', params: { page: { number: i, size: 100 } })

        try = 0
        while (resp.status != 200 && try < 5) do
          logger.warn "Retrying page #{i} because the request failed"
          sleep(2)
          resp = fortytwo_api_client.get_response('/v2/coalitions', params: { page: { number: i, size: 100 } })
        end

        if try == 5 then
          raise IntraAPIError, "tried and failed to fetch coalition page #{i} five times"
        end

        resp.parsed.each do |data|
          coalition = Coalition.find_or_create_by!(fortytwo_id: data['id'])
          coalition.update!(name: data['name'], cover_url: data['cover_url'])
        end

        logger.info "Done fetching page #{i} of coalitions."

        i += 1
      end

    end

    logger.info 'Done fetching all coalitions.'
    return true
  end
end
