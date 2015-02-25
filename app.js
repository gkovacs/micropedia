// Generated by LiveScript 1.3.1
(function(){
  var express, fs, glob, marked, app, ref$, listproblems, listproblems_markdown, listproblems_html, page_markdown, page_html;
  express = require('express');
  fs = require('fs');
  glob = require('glob');
  marked = require('marked');
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
  listproblems = function(topic, callback){
    return glob('w/' + topic + '/*-problem.md', function(err, files){
      var res$, i$, len$, x;
      res$ = [];
      for (i$ = 0, len$ = files.length; i$ < len$; ++i$) {
        x = files[i$];
        res$.push(x.substring(x.lastIndexOf('/') + 1));
      }
      files = res$;
      res$ = [];
      for (i$ = 0, len$ = files.length; i$ < len$; ++i$) {
        x = files[i$];
        res$.push(x.substring(0, x.length - 3));
      }
      files = res$;
      return callback(files);
    });
  };
  app.get('/listproblems', function(req, res){
    return listproblems(function(files){
      return res.send(JSON.stringify(files));
    });
  });
  listproblems_markdown = function(topic, callback){
    return listproblems(topic, function(files){
      var output, i$, len$, fn;
      output = [];
      for (i$ = 0, len$ = files.length; i$ < len$; ++i$) {
        fn = files[i$];
        output.push("[" + fn + "](" + fn + ")");
      }
      return callback(output.join('\n\n'));
    });
  };
  listproblems_html = function(topic, callback){
    return listproblems_markdown(topic, function(mdata){
      return callback(marked(mdata));
    });
  };
  app.get('/markdown/problems', function(req, res){
    var topic, ref$;
    topic = (ref$ = req.query.topic) != null ? ref$ : '**';
    return listproblems_markdown(topic, function(output){
      res.type('text/plain');
      return res.send(output);
    });
  });
  app.get('/w/problems', function(req, res){
    var topic, ref$;
    topic = (ref$ = req.query.topic) != null ? ref$ : '**';
    return listproblems_html(topic, function(output){
      res.type('text/html');
      return res.send(output);
    });
  });
  page_markdown = function(name, callback){
    var pattern, matches, filepath, contents;
    pattern = 'w/**/' + name + '.md';
    matches = glob.sync(pattern);
    if (matches.length === 0) {
      callback(null);
      return;
    }
    filepath = matches[0];
    contents = fs.readFileSync(filepath, 'utf8');
    return callback(contents);
  };
  page_html = function(name, callback){
    return page_markdown(name, function(mdata){
      if (mdata === null) {
        return callback(null);
      } else {
        return callback(marked(mdata));
      }
    });
  };
  app.get(/^\/w\/(.+)/, function(req, res){
    var name;
    name = req.params[0];
    return page_html(name, function(data){
      res.type('text/html');
      if (data === null) {
        return res.send('article does not exist: ' + name);
      } else {
        return res.send(data);
      }
    });
  });
  app.get(/^\/markdown\/(.+)/, function(req, res){
    var name;
    name = req.params[0];
    return page_markdown(name, function(data){
      res.type('text/plain');
      if (data === null) {
        return res.send('article does not exist: ' + name);
      } else {
        return res.send(data);
      }
    });
  });
  app.get(/^\/metadata\/(.+)/, function(req, res){
    var filename, pattern, matches, filepath;
    filename = req.params[0];
    pattern = 'w/**/' + filename + '.yaml';
    matches = glob.sync(pattern);
    if (matches.length === 0) {
      res.send('metadata does not exist: ' + filename);
      return;
    }
    filepath = matches[0];
    return res.sendFile(filepath, {
      root: __dirname
    });
  });
  app.get(/^\/png\/(.+)/, function(req, res){
    var filename, pattern, matches, filepath;
    filename = req.params[0];
    pattern = 'w/**/' + filename + '.png';
    matches = glob.sync(pattern);
    if (matches.length === 0) {
      res.send('png does not exist: ' + filename);
      return;
    }
    filepath = matches[0];
    return res.sendFile(filepath, {
      root: __dirname
    });
  });
  app.get(/^\/js\/(.+)/, function(req, res){
    var filename, pattern, matches, filepath;
    filename = req.params[0];
    pattern = 'w/**/' + filename + '.js';
    matches = glob.sync(pattern);
    if (matches.length === 0) {
      res.send('js does not exist: ' + filename);
      return;
    }
    filepath = matches[0];
    return res.sendFile(filepath, {
      root: __dirname
    });
  });
}).call(this);
