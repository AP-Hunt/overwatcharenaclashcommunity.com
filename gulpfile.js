const { series, parallel, src, dest, pipe, watch } = require("gulp");
const sass = require("gulp-sass");
const rimraf = require("rimraf");
const pug = require("gulp-pug");
const webserver = require("gulp-webserver");
const fs = require("fs");
const path = require("path");
const rename = require("gulp-rename");

const SOURCES = {
    scss: "src/scss/**/*.scss",
    js: "node_modules/tablesort/dist/**/*.js",
    pug: [
        "src/pug/**/*.pug",
        "!src/pug/**/_*",
        "!src/pug/archives.pug"
    ],
    pug_archives: "src/pug/archives.pug",
    data: {
        currentSeason: "src/data/current/",
        archives: "src/data/archives/"
    }
}

const DESTINATIONS = {
    css: "dist/css/",
    js: "dist/js/",
    html: {
        current: "dist/",
        archives: function (title) {
            return path.join("dist/archives/", title);
        }
    }
}

function buildCSS() {
    return src(SOURCES.scss)
        .pipe(sass().on("error", sass.logError))
        .pipe(dest(DESTINATIONS.css))
}

function buildHTML(done) {
    return series(buildCurrentSeason, buildArchives)(done);
}

function buildCurrentSeason(done) {
    let data = importData(SOURCES.data.currentSeason);
    return renderPug(data, DESTINATIONS.html.current);
}

function buildArchives(done) {
    let archiveEntries = fs.readdirSync(SOURCES.data.archives);
    let generators = [];
    let archives = { archives: [] };
    for (var dir in archiveEntries) {
        if (archiveEntries.hasOwnProperty(dir)) {
            dir = archiveEntries[dir];
            let fullPath = path.join(SOURCES.data.archives, dir);
            let data = importData(fullPath);
            let outputPath = DESTINATIONS.html.archives(dir);
            archives.archives.push({
                "name": data._meta.title,
                "path": "/archives/"+dir+"/index.html"
            });
            generators.push(function () {
                return renderPug(data, outputPath);
            });
        }
    }
    let buildArchiveIndex = function(){
        return src(SOURCES.pug_archives)
        .pipe(
            pug({
                data: archives
            })
        )
        .pipe(rename("index.html"))
        .pipe(dest(DESTINATIONS.html.archives(".")));
    }

    generators.push(buildArchiveIndex);

    return parallel(generators)(done);
}


function importData(targetDir) {
    let data = {};
    let dirEntries = fs.readdirSync(targetDir);
    for (var f in dirEntries) {
        if (dirEntries.hasOwnProperty(f)) {
            let fileName = dirEntries[f];
            let filePath = path.join(targetDir, fileName);
            var contents = JSON.parse(fs.readFileSync(filePath));
            data[fileName.split(".")[0]] = contents;
        }
    }

    return data;
}

function renderPug(data, destination) {
    return src(SOURCES.pug)
        .pipe(
            pug({
                data: data
            })
        )
        .pipe(dest(destination));
}

function buildJS(done) {
    return src(SOURCES.js)
        .pipe(dest(DESTINATIONS.js));
}

function clean(done) {
    rimraf("dist/", done);
}

function serve() {
    return src(DESTINATIONS.html.current)
        .pipe(webserver({
            livereload: true,
            open: true,
            host: "localhost",
            port: 9090,
            fallback: "index.html"
        }));
}

function watchFiles() {
    watch(SOURCES.data.currentSeason, buildHTML);
    watch(SOURCES.data.archives, buildHTML);
    watch(SOURCES.js, buildJS);
    watch(SOURCES.scss, buildCSS);
    watch(SOURCES.pug, buildHTML);
}

exports.default = series(clean, buildCSS, buildHTML, buildJS);
exports.buildCSS = buildCSS;
exports.buildJS = buildJS;
exports.buildHTML = buildHTML;
exports.serve = serve;
exports.watch = series(exports.default, serve, watchFiles);