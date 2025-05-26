//= require_self

// StompBase Admin Dashboard JavaScript

window.StompBase = {
  // Initialize the dashboard
  init: function() {
    this.bindEvents();
    this.setupConsole();
  },

  // Bind global events
  bindEvents: function() {
    // Add any global event listeners here
    document.addEventListener('DOMContentLoaded', function() {
      console.log('StompBase Dashboard loaded');
    });
  },

  // Setup console functionality
  setupConsole: function() {
    const consoleForm = document.getElementById('console-form');
    if (consoleForm) {
      consoleForm.addEventListener('submit', this.handleConsoleSubmit.bind(this));
    }
  },

  // Handle console command submission
  handleConsoleSubmit: function(event) {
    event.preventDefault();
    const input = document.getElementById('console-input');
    const output = document.getElementById('console-output');
    
    if (!input || !output) return;
    
    const code = input.value.trim();
    if (!code) return;
    
    this.executeConsoleCommand(code, output);
  },

  // Execute console command
  executeConsoleCommand: function(code, outputElement) {
    const timestamp = new Date().toLocaleTimeString();
    outputElement.innerHTML += `\n[${timestamp}] > ${code}\n`;
    
    // This would typically make an AJAX request to the server
    // For now, just show a placeholder response
    outputElement.innerHTML += `[INFO] Command executed (placeholder response)\n`;
    outputElement.scrollTop = outputElement.scrollHeight;
  },

  // Utility functions
  utils: {
    // Format bytes to human readable format
    formatBytes: function(bytes, decimals = 2) {
      if (bytes === 0) return '0 Bytes';
      const k = 1024;
      const dm = decimals < 0 ? 0 : decimals;
      const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
      const i = Math.floor(Math.log(bytes) / Math.log(k));
      return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
    },

    // Show notification
    showNotification: function(message, type = 'info') {
      const notification = document.createElement('div');
      notification.className = `stomp-base-alert stomp-base-alert-${type}`;
      notification.textContent = message;
      
      const container = document.querySelector('.stomp-base-container');
      if (container) {
        container.insertBefore(notification, container.firstChild);
        
        // Auto-remove after 5 seconds
        setTimeout(() => {
          if (notification.parentNode) {
            notification.parentNode.removeChild(notification);
          }
        }, 5000);
      }
    }
  }
};

// Initialize when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', function() {
    StompBase.init();
  });
} else {
  StompBase.init();
}
