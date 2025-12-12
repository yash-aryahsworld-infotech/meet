class AppConfig {
  // 🔧 CONFIGURATION
  // Change this based on your environment
  static const bool useProduction = true; // Set to true when deploying to production
  
  // 🌐 PRODUCTION SERVER
  // Replace with your actual production server URL
  static const String productionServerUrl = 'https://meet-server-wkkb.onrender.com';
  
  // 💻 DEVELOPMENT SERVER (Local testing)
  // 
  // IMPORTANT: Choose the right URL based on your setup:
  // 
  // 1. Android Emulator connecting to server on same PC:
  //    Use: 'http://10.0.2.2:3001'
  //    (10.0.2.2 is the special IP that Android emulator uses to reach host machine)
  //
  // 2. Physical Device on same WiFi network:
  //    Use: 'http://YOUR_COMPUTER_IP:3001'
  //    Find your IP: 
  //    - Windows: Open CMD and type 'ipconfig', look for IPv4 Address
  //    - Mac/Linux: Open Terminal and type 'ifconfig' or 'ip addr'
  //    Example: 'http://192.168.1.13:3001'
  //
  // 3. iOS Simulator:
  //    Use: 'http://localhost:3001'
  //
  // static const String developmentServerUrl = 'http://192.168.1.12:3001';
  
  // 📱 Get the appropriate server URL based on environment
  static String get serverUrl {
    return useProduction ? productionServerUrl : developmentServerUrl;
  }
  
  // 🔍 Check if using production
  static bool get isProduction => useProduction;
  
  // 📊 Get environment name
  static String get environment => useProduction ? 'Production' : 'Development';
} 
