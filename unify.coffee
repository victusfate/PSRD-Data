#!/usr/bin/env coffee

fs    = require('fs')
path  = require('path')
util  = require('util')

topPath = process.argv[2]

compileRules = (callback = console.log) ->

    dirTree = (filename, obj) ->
        info = {
            path: filename,
            name: path.basename(filename)
        }

        if fs.lstatSync(filename).isDirectory()
            obj[info.name] = {}
            fs.readdirSync(filename).map (child) ->
                dirTree(filename + '/' + child, obj[info.name])
        else
            obj[info.name] = JSON.parse fs.readFileSync(info.path) if info.name.match(/json/)
            delete obj[info.name].sections

    obj = {}
    # console.log(util.inspect(dirTree(topPath,obj), false, null))
    dirTree(topPath,obj)
    baseName = path.basename(topPath)
    fs.writeFileSync './' + baseName + '.json', baseName.toUpperCase() + '=' + JSON.stringify(obj,null,'  ')
    callback() if callback

compileRules()