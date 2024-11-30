import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['link', 'icon', 'span']

  async copy() {
    const text = document.getElementById('leaderboard-id')?.textContent;
    if (typeof(text) != 'string') {
      throw Error('could not find leaderboard id');
    }
    await navigator.clipboard.writeText(text);

    this.iconTarget.classList.remove('bi-clipboard');
    this.iconTarget.classList.add('bi-check');

    this.linkTarget.classList.remove('text-primary');
    this.linkTarget.classList.add('text-success');

    this.spanTarget.textContent = "Copied!";

    return false;
  }
}
