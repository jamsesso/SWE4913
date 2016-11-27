var path = require('path');
var webpack = require('webpack');
var merge = require('webpack-merge');
var CopyWebpackPlugin = require('copy-webpack-plugin');
var HtmlWebpackPlugin = require('html-webpack-plugin');

var TARGET_ENV = process.env.npm_lifecycle_event === 'build' ? 'production' : 'development';
var pageArg = process.argv.indexOf('--page');

// This is really an awful way to do this, but setting multiple entry points
// causes some pretty strange inter-mixing of code to happen. Perhaps the
// `elm-webpack` loader is stateful causing some race condition?
if(pageArg < 0 || process.argv.length <= pageArg + 1) {
  throw 'Pass a page to build';
}

function makeConfig(page) {
  return {
    entry: path.join(__dirname, 'src/js/' + page + '.js'),
    output: {
      path: 'docs/',
      filename: page + '.js',
    },
    resolve: {
      modulesDirectories: ['node_modules'],
      extensions: ['', '.js', '.elm']
    },
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
    plugins: [
      new HtmlWebpackPlugin({
        template: 'src/static/html/' + page + '.html',
        inject: 'body',
        filename: page + '.html'
      }),
      new CopyWebpackPlugin([
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
}

module.exports = makeConfig(process.argv[pageArg + 1]);
