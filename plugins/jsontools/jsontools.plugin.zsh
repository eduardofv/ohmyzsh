# JSON Tools
# Adds command line aliases useful for dealing with JSON

if [[ $(whence $JSONTOOLS_METHOD) = "" ]]; then
	JSONTOOLS_METHOD=""
fi

if [[ $(whence node) != "" && ( "x$JSONTOOLS_METHOD" = "x"  || "x$JSONTOOLS_METHOD" = "xnode" ) ]]; then
	alias pp_json='xargs -0 node -e "console.log(JSON.stringify(JSON.parse(process.argv[1]), null, 4));"'
	alias is_json='xargs -0 node -e "try {json = JSON.parse(process.argv[1]);} catch (e) { console.log(false); json = null; } if(json) { console.log(true); }"'
	alias urlencode_json='xargs -0 node -e "console.log(encodeURIComponent(process.argv[1]))"'
	alias urldecode_json='xargs -0 node -e "console.log(decodeURIComponent(process.argv[1]))"'
elif [[ $(whence python) != "" && ( "x$JSONTOOLS_METHOD" = "x" || "x$JSONTOOLS_METHOD" = "xpython" ) ]]; then
	alias pp_json='python -c "import sys; del sys.path[0]; import runpy; runpy._run_module_as_main(\"json.tool\")"'
	alias pp_ndjson='python -c "
import sys; del sys.path[0];
import json;
for line in sys.stdin.readlines():
	j = json.loads(line)
	print(json.dumps(j, indent=4))
sys.exit(0)"'
	alias is_json='python -c "
import sys; del sys.path[0];
import json;
try: 
	json.loads(sys.stdin.read())
except ValueError, e: 
	print False
else:
	print True
sys.exit(0)"'
	alias urlencode_json='python -c "
import sys; del sys.path[0];
import urllib, json;
print urllib.quote_plus(sys.stdin.read())
sys.exit(0)"'
	alias urldecode_json='python -c "
import sys; del sys.path[0];
import urllib, json;
print urllib.unquote_plus(sys.stdin.read())
sys.exit(0)"'
elif [[ $(whence ruby) != "" && ( "x$JSONTOOLS_METHOD" = "x" || "x$JSONTOOLS_METHOD" = "xruby" ) ]]; then
	alias pp_json='ruby -e "require \"json\"; require \"yaml\"; puts JSON.parse(STDIN.read).to_yaml"'
	alias pp_ndjson='ruby -e "require \"json\"; require \"yaml\"; STDIN.read.split(\"\n\").each{|l| puts(JSON.parse(l).to_yaml)}"'
	alias is_json='ruby -e "require \"json\"; begin; JSON.parse(STDIN.read); puts true; rescue Exception => e; puts false; end"'
	alias urlencode_json='ruby -e "require \"uri\"; puts URI.escape(STDIN.read)"'
	alias urldecode_json='ruby -e "require \"uri\"; puts URI.unescape(STDIN.read)"'
fi

unset JSONTOOLS_METHOD
