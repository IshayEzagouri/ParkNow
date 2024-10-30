const path = require('path');

module.exports = {
  entry: './Backend/src/socket.js', // Entry file
  output: {
    path: path.resolve(__dirname, 'dist'), // Output directory
    filename: 'bundle.js' // Output file
  },
  module: {
    rules: [
      {
        test: /\.jsx?$/, // Match .js and .jsx files
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader' // Use Babel to transpile
        }
      }
    ]
  },
  resolve: {
    extensions: ['.js', '.jsx'], // Resolve these extensions
    fallback: {
      fs: false, // Do not include 'fs' in the bundle
      path: require.resolve('path-browserify'), // Provide a browser-compatible path
      os: require.resolve('os-browserify/browser') // Provide a browser-compatible os module
    }
  }
};
