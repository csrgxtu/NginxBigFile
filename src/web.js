var http = require('http');

function process_request(req, res) {
  console.log('DEBUG: fuck');
  console.log(req);
  var body = "thanks for calling\n";
  var content_length = body.length;
  res.writeHead(200, {
    'Content-Length': content_length,
    'Content_Type': 'text/plain'
  });
  res.end(body);
}

var s = http.createServer(process_request);
s.listen(8882);
