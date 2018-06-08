//
//  Facade.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

final class Facade {
    let sprintService: SprintService
    let issueService: IssueService
    let projectService: ProjectService
    let jqlService: JQLService
    let configService: ConfigService
    let boardService: BoardService

    init(session: URLSession = .shared,
         configManager: ConfigManager = .shared,
         projectAliasManager: ProjectAliasManager = .shared,
         jqlAliasManager: JQLAliasManager = .shared) {
        let configService = ConfigService(manager: configManager)
        let jiraSession = JiraSession(session: session,
                                      domain: { try configService.loadConfig().domain },
                                      apiKey: { try configService.loadConfig().apiKey },
                                      username: { try configService.loadConfig().username })
        self.sprintService = SprintService(session: jiraSession)
        self.issueService = IssueService(session: jiraSession)
        self.projectService = ProjectService(session: jiraSession, aliasManager: projectAliasManager)
        self.jqlService = JQLService(aliasManager: jqlAliasManager)
        self.configService = configService
        self.boardService = BoardService(session: jiraSession)
    }
}
