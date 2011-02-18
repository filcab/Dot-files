// Kod init script

var util = require('util');
var kod = require('kod');

for (var prop in kod) {
  console.log(prop + ' -> ' + kod[prop]);
}

console.log('main.js started. kod -> '+util.inspect(kod));
console.log('process.env -> '+util.inspect(process.env));

require.paths.push(process.env.HOME + '/.kod');

console.log('require.paths -> ' + util.inspect(require.paths));

