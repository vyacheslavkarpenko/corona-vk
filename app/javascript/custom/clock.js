
window.onload = () => {
  let curretntDate = () => {
    let d = new Date()
    return d.getDate() + "." + d.getMonth() + "." + d.getFullYear() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds()
  }

  // setInterval(() => { console.log(curretntDate()) }, 1000)
  setInterval(() => {document.getElementById("clock").innerHTML = curretntDate()});
}
