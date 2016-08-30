import Foundation

struct InflatedPost {
    let post: Post
    
    let user: User
}

extension InflatedPost: Equatable { }

func ==(lhs: InflatedPost, rhs: InflatedPost) -> Bool {
    let postsEqual = lhs.post.id == rhs.post.id
    let usersEqual = lhs.user.authData.id == lhs.user.authData.id
    
    return postsEqual && usersEqual
}
