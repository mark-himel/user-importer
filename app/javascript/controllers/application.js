import { Application } from "@hotwired/stimulus";

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

import UserImportController from './user_import';

application.register('user-import', UserImportController);

export { application }
