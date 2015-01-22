// Generated by LiveScript 1.3.1
(function(){
  var express, fs, markdown, app, ref$;
  express = require('express');
  fs = require('fs');
  markdown = require('markdown').markdown;
  app = express();
  app.set('view engine', 'jade');
  app.set('views', __dirname + '/static');
  app.use(express['static'](__dirname + '/static'));
  app.listen((ref$ = process.env.PORT) != null ? ref$ : 3000);
  app.get('/feed', function(req, res){
    return res.render('feed', {});
  });
  app.get('/', function(req, res){
    return res.render('feed', {});
  });
  app.get('/w', function(req, res){
    return res.redirect('/w/index');
  });
  app.get('/wiki', function(req, res){
    return res.redirect('/w/index');
  });
  app.get(/^\/w\/(.+)/, function(req, res){
    var filename, filepath, contents;
    filename = req.params[0];
    filepath = 'w/' + filename + '.md';
    if (!fs.existsSync(filepath)) {
      res.send('article does not exist: ' + filename);
      return;
    }
    contents = fs.readFileSync(filepath, 'utf8');
    return res.send(markdown.toHTML(contents));
  });
  app.get(/^\/markdown\/(.+)/, function(req, res){
    var filename, filepath, contents;
    filename = req.params[0];
    filepath = 'w/' + filename + '.md';
    if (!fs.existsSync(filepath)) {
      res.send('article does not exist: ' + filename);
      return;
    }
    contents = fs.readFileSync(filepath, 'utf8');
    res.type('text/plain');
    return res.send(contents);
  });
}).call(this);
