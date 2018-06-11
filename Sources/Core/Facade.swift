//
//  Facade.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

public final class Facade {
    public let sprintService: SprintService
    public let issueService: IssueService
    public let projectService: ProjectService
    public let jqlService: JQLService
    public let configService: ConfigService
    public let boardService: BoardService

    public convenience init() {
        self.init(session: .shared,
                  configManager: .shared,
                  projectAliasManager: .shared,
                  jqlAliasManager: .shared,
                  boardDataManager: .shared,
                  sprintDataManager: .shared)
    }

    public init(session: URLSession,
                configManager: ConfigManager,
                projectAliasManager: ProjectAliasManager,
                jqlAliasManager: JQLAliasManager,
                boardDataManager: BoardDataManager,
                sprintDataManager: SprintDataManager) {
        let configService = ConfigService(manager: configManager)
        let jiraSession = JiraSession(session: session,
                                      domain: { try configService.loadConfig().domain },
                                      apiKey: { try configService.loadConfig().apiKey },
                                      username: { try configService.loadConfig().username })
        self.sprintService = SprintService(session: jiraSession, sprintDataManager: sprintDataManager)
        self.issueService = IssueService(session: jiraSession)
        self.projectService = ProjectService(session: jiraSession, aliasManager: projectAliasManager)
        self.jqlService = JQLService(aliasManager: jqlAliasManager)
        self.configService = configService
        self.boardService = BoardService(session: jiraSession, boardDataManager: boardDataManager)
    }
}
