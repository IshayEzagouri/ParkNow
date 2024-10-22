const path = require('path');

module.exports = {
  entry: './Backend/socket.js', // Change this to your entry file
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
    extensions: ['.js', '.jsx'] // Resolve these extensions
  }
};
