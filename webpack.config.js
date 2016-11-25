var path = require('path');
var webpack = require('webpack');
var merge = require('webpack-merge');
var CopyWebpackPlugin = require('copy-webpack-plugin');

var TARGET_ENV = process.env.npm_lifecycle_event === 'build' ? 'production' : 'development';

var commonConfig = {
  entry: {
    index: path.join(__dirname, 'src/js/index.js'),
    tutorial1: path.join(__dirname, 'src/js/tutorial1.js'),
    tutorial2: path.join(__dirname, 'src/js/tutorial2.js'),
    tutorial3: path.join(__dirname, 'src/js/tutorial3.js')
  },
  output: {
    path: path.resolve(__dirname, 'docs/'),
    filename: '[name].js',
  },
  resolve: {
    modulesDirectories: ['node_modules'],
    extensions: ['', '.js', '.elm']
  },
  plugins: [
    new CopyWebpackPlugin([
      {
        from: 'src/static/html/',
      },
      {
        from: 'src/static/img/',
        to: 'static/img/'
      },
      {
        from: 'src/favicon.ico'
      },
      {
        from: 'src/style.css'
      },
      {
        from: 'src/highlight.pack.js'
      }
    ])
  ]
}

// additional webpack settings for local env (when invoked by 'npm start')
if (TARGET_ENV === 'development') {
  module.exports = merge(commonConfig, {
    devServer: {
      inline: true,
      progress: true
    },
    module: {
      noParse: /\.elm$/,
      loaders: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          loader: 'elm-hot!elm-webpack?verbose=true&warn=true'
        }
      ]
    }
  });
}

// additional webpack settings for prod env (when invoked via 'npm run build')
if (TARGET_ENV === 'production') {
  module.exports = merge(commonConfig, {
    module: {
      noParse: /\.elm$/,
      loaders: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          loader: 'elm-webpack'
        }
      ]
    },
    plugins: commonConfig.plugins.concat([
      new webpack.optimize.OccurenceOrderPlugin(),
      new webpack.optimize.UglifyJsPlugin({
        minimize: true,
        compressor: {
          warnings: false
        }
      })
    ])
  });
}
