# use d3 to convert csv to json

d3 = require "d3"
JSV = (require "JSV").JSV

if not d3? or not JSV?
	console.log "cannot find d3 or JSV, use command: coffee -r d3 -r JSV _convert.coffee"
	return

fs = require "fs"

fs.readdir "./", (error, files) ->
	for filename in files when filename.match ".csv"
		
		# 1 convert csv to json data
		console.log "converting csv : #{filename}"
		jsonData = d3.csv.parse String(fs.readFileSync filename)

		# 2 if exist schema.json then validation it
		schemaFilename = filename.replace ".csv", ".schema.json"
		if fs.existsSync schemaFilename
			schemaData = JSON.parse String(fs.readFileSync schemaFilename)
			report = JSV.createEnvironment().validate jsonData, schemaData
			if report.errors.length isnt 0
				console.log report.errors
				console.log "validate fail, schema : #{schemaFilename}"
			else
				console.log "validate success by : #{schemaFilename}"

		# 3 write json to file
		jsonFilename = filename.replace ".csv", ".json"
		fs.writeFileSync jsonFilename, JSON.stringify jsonData
		console.log "write csv: #{filename} , to json: #{jsonFilename}"
	