import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log('user import is connected');
  }

  import() {
    this.element.requestSubmit();
  }
}
