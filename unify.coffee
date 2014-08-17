#!/usr/bin/env coffee

fs    = require('fs')
path  = require('path')
util  = require('util')

topPath = process.argv[2]
output = topPath.split('/')[0]

nukeIfNoStrength = (oObj) ->
    if oObj.text
        delete oObj.text
    if oObj.sections
        for oSection,i in oObj.sections
            nukeIfNoStrength(oObj.sections[i])
    if !oObj.strength and !(oObj instanceof Array)
        for oVar,iKey of oObj when iKey != 'sections'
            delete oObj[iKey]
    null

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
            nukeIfNoStrength(obj[info.name])

    obj = {}
    # console.log(util.inspect(dirTree(topPath,obj), false, null))
    dirTree(topPath,obj)
    fs.writeFileSync './' + output + '.json', output.toUpperCase() + '=' + JSON.stringify(obj,null,'  ')
    callback() if callback

compileRules()