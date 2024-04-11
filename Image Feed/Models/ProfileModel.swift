struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(data: ProfileResult) {
        self.username = data.username
        self.name = (data.firstName) + " " + (data.lastName ?? "")
        self.loginName = "@" + (data.username )
        self.bio = data.bio
    }
}
