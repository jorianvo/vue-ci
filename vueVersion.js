const pjson = require('./package.json');
const vueVersion = pjson.dependencies["@vue/cli"];

if (process.argv[2] && process.argv[2] === '--short') {
    const majorAndPatchVersion = vueVersion.match(/\d+\.\d+/g)[0];
    console.log(majorAndPatchVersion);
} else {
    console.log(vueVersion);
}