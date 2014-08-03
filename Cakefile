compileRules = (callback = console.log) ->
    fs    = require('fs')
    path  = require('path')
    util  = require('util')

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

    obj = {}
    # console.log(util.inspect(dirTree('monsters',obj), false, null))
    dirTree('monsters',obj)
    fs.writeFileSync 'fullMonsters.json', 'MONSTERS=' + JSON.stringify(obj,null,'  ')
    callback() if callback

task 'compileRules', 'Suck in tree of json files and create one master file', -> compileRules()