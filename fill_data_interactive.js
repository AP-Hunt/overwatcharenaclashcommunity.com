const prompt = require("prompt");
const fs = require("fs");

/**
 * @param {string} team 
 * @returns {Promise([number, number, number])}
 */
function promptUser(team) {
    const schema = {
        properties: {
            played: {
                description: "Played",
                type: 'integer',
                pattern: /^\d+$/,
                required: true
            },
            won: {
                description: "Won",
                type: 'integer',
                pattern: /^\d+$/,
                required: true
            },
            lost: {
                description: "Lost",
                type: 'integer',
                pattern: /^\d+$/,
                required: true
            }
        }
    }


    return new Promise((resolve, reject) => {
        console.info(team);
        prompt.start();

        prompt.get(schema, function(err, result){
            if(err){
                reject(err);
                return;
            }

            resolve({ 
                played: result.played, 
                won: result.won, 
                lost: result.lost 
            });
        })
    })
}

async function fillDataInteractive(done){
    const leagues = JSON.parse(fs.readFileSync("./src/data/current/groups.json"))

    try
    {
        // Each league
        for (key in leagues.leagues) {
            if (leagues.leagues.hasOwnProperty(key)){
                var league = leagues.leagues[key];
                console.info("=> " + key + "\n\n");
                // Each group
                for(var i = 0; i <= league.length-1; i++){
                    var group = league[i];
                    console.info("==> " + group.name + "\n\n");

                    // Each team
                    for(var j = 0; j <= group.teams.length-1; j++){
                        var accept = true;
                        do
                        {
                            accept = true;
                            var result = await promptUser(group.teams[j].name);
                            
                            if( (result.won + result.lost) != result.played ) {
                                console.warn("Won + Lost != Played. Try again.");
                                accept = false;
                                continue;
                            }

                            group.teams[j].played = result.played;
                            group.teams[j].won = result.won;
                            group.teams[j].lost = result.lost;
                            group.teams[j].points = result.won;
                        }
                        while(!accept)
                    }
                }
            }
        }    

        fs.writeFileSync("./src/data/current/groups.json", JSON.stringify(leagues, null, 2));

        done();
    } catch (e) {
        console.error(e);
        done();
        return;
    }
}

exports.fillDataInteractive = fillDataInteractive;