var readline = require("readline")
var uniqueInvoice = {}
var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
})

rl.on("line", function(line) {
  var str = line.split(",")
  if (str.length > 4) {
    var invoiceNumber = str[0]
    if (uniqueInvoice[invoiceNumber]) {
      uniqueInvoice[invoiceNumber].products.push(`"${str[2]}"`)
    } else {
      uniqueInvoice[invoiceNumber] = {
        products: [`"${str[2]}"`]
      }
    }
  }
})

rl.on("close", function() {
  for (const key of Object.keys(uniqueInvoice)) {
    console.log(uniqueInvoice[key].products.join(","))
  }
})
