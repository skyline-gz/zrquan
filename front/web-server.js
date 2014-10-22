var http = require("http");
var url = require("url");
var fs = require("fs");
var path = require("path");
var mime = {
    "css": "text/css",

    "gif": "image/gif",

    "html": "text/html",

    "ico": "image/x-icon",

    "jpeg": "image/jpeg",

    "jpg": "image/jpeg",

    "js": "text/javascript",

    "json": "application/json",

    "pdf": "application/pdf",

    "png": "image/png",

    "svg": "image/svg+xml",

    "swf": "application/x-shockwave-flash",

    "tiff": "image/tiff",

    "txt": "text/plain",

    "wav": "audio/x-wav",

    "wma": "audio/x-ms-wma",

    "wmv": "video/x-ms-wmv",

    "xml": "text/xml"
};

http.createServer(function(request, response) {
    var pathname = url.parse(request.url).pathname;
    var realpath = 'src' + (pathname == '/' ? 'index.html' : pathname);      // dev
//    var realpath = 'build/' + (pathname == '/' ? 'index.html' : pathname);      // release
    console.log("request path: " + realpath);

    path.exists(realpath, function(exists) {
        if (!exists) {
            response.writeHead(404, {"Content-Type": "text/plain"});
            response.write("This request URL " + pathname + " was not found on this server");
            response.end();
        } else {
            fs.readFile(realpath, "binary", function(err, file) {
                if (err) {
                    response.writeHead(500, {"Content-Type": "text/plain"});
                    response.end(err);
                } else {
                    var ext = path.extname(realpath);
                    ext = ext ? ext.slice(1) : "unknown";
                    var contentType = mime[ext] || "text/plain";
                    response.writeHead(200, {"Content-Type": contentType});
                    response.write(file, "binary");
                    response.end();
                }
            })
        }
    })
}).listen(8888);

console.log("server listen in 8888...");

