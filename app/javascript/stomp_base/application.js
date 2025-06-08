// StompBase Admin Dashboard JavaScript
import { Application } from "@hotwired/stimulus"

const application = Application.start()

// StompBase namespace
window.StompBase = {
  // Initialize the dashboard
  init: function() {
    console.log('StompBase Dashboard initialized');
    this.bindEvents();
  },

  // Bind global events
  bindEvents: function() {
    document.addEventListener('DOMContentLoaded', function() {
      console.log('StompBase Dashboard loaded');
    });
  }
};

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
  window.StompBase.init();
});

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
  window.StompBase.init();
});
