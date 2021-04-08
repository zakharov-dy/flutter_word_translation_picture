var axios = require("axios").default;
var fs = require('fs');
var raw = JSON.parse(fs.readFileSync('data.json', 'utf8'));

const start = async () => {
    console.log('Start');
    for (let index = 0; index < raw.length; index++) {
        const translate = raw[index];
        const url = await getUrl(translate.en);
        raw[index].url = url;
      }
    
    complete(raw);
}
// Very bad way ((( 
const getUrl = async (en) => {
    var options = {
        method: 'GET',
        url: 'https://contextualwebsearch-websearch-v1.p.rapidapi.com/api/Search/ImageSearchAPI',
        params: {q: en, pageNumber: '1', pageSize: '1', autoCorrect: 'true'},
        headers: {
          // secret.env
          'x-rapidapi-key': '****',
          'x-rapidapi-host': 'contextualwebsearch-websearch-v1.p.rapidapi.com'
        }
       };
    console.log('getUrl');
    const resp = await axios.request(options);
    const res = resp.data;
    console.log('sleep');
    await sleep(500);
    console.log(res);
    if(res && res.value && res.value.length > 0){
        console.log(res.value[0].url);
        return res.value[0].url;
    } else {
        return null;
    }
}

const sleep = ms => new Promise(resolve => setTimeout(resolve, ms))


const complete = (data) => fs.writeFile('result.json', JSON.stringify(data), (err) => {
    if (err) {
        throw err;
    }
    console.log("JSON data is saved.");
});

// getUrl('ability to multitask');
start();