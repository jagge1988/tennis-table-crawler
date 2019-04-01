import Cocoa
import PlaygroundSupport

let team = "Damen 40"

PlaygroundPage.current.needsIndefiniteExecution = true
let teams = ["Damen 40", "Herren", "Herren 40", "Herren 70", "Herren 65", "Jugend U14"]
let teamGroups = ["Damen 40": "20", "Herren": "2", "Herren 40" : "6", "Herren 70": "16", "Herren 65": "1342565", "Jugend U14": "26"]
let teamLinks = ["Herren 65": "http://tmv.liga.nu/cgi-bin/WebObjects/nuLigaTENDE.woa/wa/groupPage?championship=RLNO+2019&group=",
                  "Damen 40": "http://tmv.liga.nu/cgi-bin/WebObjects/nuLigaTENDE.woa/wa/groupPage?championship=TMV+Sommer+2019&group=",
                  "Herren": "http://tmv.liga.nu/cgi-bin/WebObjects/nuLigaTENDE.woa/wa/groupPage?championship=TMV+Sommer+2019&group=",
                  "Herren 40": "http://tmv.liga.nu/cgi-bin/WebObjects/nuLigaTENDE.woa/wa/groupPage?championship=TMV+Sommer+2019&group=",
                  "Herren 70": "http://tmv.liga.nu/cgi-bin/WebObjects/nuLigaTENDE.woa/wa/groupPage?championship=TMV+Sommer+2019&group=",
                  "Jugend U14": "http://tmv.liga.nu/cgi-bin/WebObjects/nuLigaTENDE.woa/wa/groupPage?championship=TMV+Sommer+2019&group="]

func getTeamUrl(team: String) -> URL {
    return URL(string: "\(teamLinks[team]!)\(teamGroups[team]!)")!
}

func getTeamTable(team: String, finishHandler: @escaping (String) -> Void) {
    let task = URLSession.shared.dataTask(with: getTeamUrl(team: team)) {(data, response, error) in
        guard let data = data else { return }
        let webpage = String(data: data, encoding: .utf8)!
        //print(webpage)
        let start = webpage.range(of: "<table")
        let end = webpage.range(of: "</table>")
        let table = webpage[start!.lowerBound..<end!.upperBound]
        
        var trimmedTable = String(table).replacingOccurrences(of: "  ", with: " ", options: String.CompareOptions.regularExpression)
        for _ in 1...5 {
            trimmedTable = String(trimmedTable).replacingOccurrences(of: "  ", with: " ", options: String.CompareOptions.regularExpression)
        }
        trimmedTable = String(trimmedTable).replacingOccurrences(of: "\n", with: " ", options: String.CompareOptions.regularExpression)
        trimmedTable = String(trimmedTable).replacingOccurrences(of: "href=\"", with: "href=\"http://tmv.liga.nu", options: String.CompareOptions.regularExpression)
        print("\n\n\n!!!!! TEAM: \(team) \n")
        print(trimmedTable)
        finishHandler(team)
    }

    task.resume()
}

func finishHandler(team: String) {
    let index = teams.firstIndex(where: { $0 == team })!
    if index >= teams.count - 1 {
        exit(0)
    } else {
        getTeamTable(team: teams[index + 1], finishHandler: finishHandler)
    }
    
}

getTeamTable(team: team, finishHandler: finishHandler)
