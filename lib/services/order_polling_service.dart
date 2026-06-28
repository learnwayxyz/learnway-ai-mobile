class OrderPollingService {
  OrderPollingService({this.pollingInterval = const Duration(seconds: 3)});

  final Duration pollingInterval;

  String generateMonitoringScript() {
    return '''
      (function() {
        console.log('Order monitoring script started');
        var pollingIntervalMs = ${pollingInterval.inMilliseconds};

        function monitorOrderStatus() {
          try {
            // Look for status text
            var statusElement = document.querySelector('.text-xl.text-center.font-bold');
            if (statusElement) {
              var status = statusElement.textContent.trim();
              console.log('Current status:', status);

              // Send status update
              if (window.FlutterChannel) {
                window.FlutterChannel.postMessage('STATUS_UPDATE:' + status);
              }

              // Check for completion keywords
              if (status.includes('Complete') ||
                  status.includes('Success') ||
                  status.includes('Confirmed') ||
                  status.includes('Done')) {

                console.log('Order completed detected!');

                // Get order ID if available
                var orderIdSpan = document.querySelector('.break-all span');
                var orderId = orderIdSpan ? orderIdSpan.textContent : 'unknown';

                // Send message to Flutter
                if (window.FlutterChannel) {
                  window.FlutterChannel.postMessage('ORDER_COMPLETED:' + orderId);
                  console.log('Sent ORDER_COMPLETED to Flutter');
                }
              } else if (status.includes('In Progress') || status.includes('Progress')) {
                console.log('Order in progress');
                if (window.FlutterChannel) {
                  window.FlutterChannel.postMessage('ORDER_IN_PROGRESS:' + status);
                }
              } else if (status.includes('Failed') || status.includes('Error') || status.includes('Cancelled')) {
                console.log('Order failed or cancelled');
                if (window.FlutterChannel) {
                  window.FlutterChannel.postMessage('ORDER_FAILED:' + status);
                }
              }
            }
          } catch (e) {
            console.error('Error monitoring status:', e);
          }
        }

        // Create MutationObserver to watch for DOM changes
        var observer = new MutationObserver(function(mutations) {
          monitorOrderStatus();
        });

        // Start observing
        observer.observe(document.body, {
          childList: true,
          subtree: true,
          characterData: true
        });

        // Poll at specified interval as backup
        setInterval(monitorOrderStatus, pollingIntervalMs);

        // Check immediately
        monitorOrderStatus();
        console.log('Monitoring setup complete');
      })();
    ''';
  }
}
