enum CustomError: Error {
    case success
    case serverError
    case databaseError
    case failure(String)
}
