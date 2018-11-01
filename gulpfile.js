const { series, src, dest, pipe } = require("gulp");
const sass  = require("gulp-sass");
const rimraf = require("rimraf");
const pug = require("gulp-pug");
const fs = require("fs");
const path = require("path");

const SOURCES = {
    scss: "src/scss/**/*.scss",
    js: "node_modules/tablesort/dist/**/*.js",
    pug: [
        "src/pug/**/*.pug",
        "!src/pug/**/_*"
    ],
    data: "src/data/"
}

const DESTINATIONS = {
    css: "dist/css/",
    js: "dist/js/",
    html: "dist/"
}

function buildCSS(){
    return src(SOURCES.scss)
        .pipe(sass().on("error", sass.logError))
        .pipe(dest(DESTINATIONS.css))
}

function buildHTML(done){
    let data = importData();
    return src(SOURCES.pug)
        .pipe(
            pug({
                data: data
            })
        )
        .pipe(dest(DESTINATIONS.html));
}
    function importData()
    {
        let data = {};
        let dirEntries = fs.readdirSync(SOURCES.data);
        for(var f in dirEntries){
            if(dirEntries.hasOwnProperty(f)){
                let fileName = dirEntries[f];
                let filePath = path.join(SOURCES.data, fileName);
                var contents = JSON.parse(fs.readFileSync(filePath));
                data[fileName.split(".")[0]] = contents; 
            }
        }

        return data;
    }

function buildJS(done) {
    return src(SOURCES.js)
        .pipe(dest(DESTINATIONS.js));
}

function clean(done){
    rimraf("dist/", done);
}

exports.buildCSS = buildCSS;
exports.buildJS = buildJS;
exports.buildHTML = buildHTML;
exports.default = series(clean, buildCSS, buildHTML, buildJS);