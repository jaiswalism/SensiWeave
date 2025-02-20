import SwiftUI

struct Constants {
    // MARK: - General
    static let appName = "SensiWeave"
    static let appTagline = "Where comfort meets style"
    
    // MARK: - Colors
    struct Colors {
        static let background = Color("BackgroundColor") // #F8F4F1
        static let primaryText = Color("PrimaryTextColor") // #1E293B
        static let secondaryText = Color("SecondaryTextColor") // #475569
        static let accent = Color("AccentColor") // #FFD700
        static let buttonBackground = Color("ButtonBackgroundColor") // #1E293B
    }
    
    // MARK: - Fonts
    struct Fonts {
        static let title = Font.custom("Poppins-SemiBold", size: 24)
        static let body = Font.custom("Roboto-Regular", size: 16)
        static let button = Font.custom("Poppins-Bold", size: 18)
    }
    
    // MARK: - Layout
    struct Layout {
        static let padding: CGFloat = 16
        static let cornerRadius: CGFloat = 8
    }
    
    // MARK: - UserDefaults Keys
    struct UserDefaultsKeys {
        static let isDarkMode = "isDarkMode"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
    
    // MARK: - Core Data
    struct CoreDataEntities {
        static let fabric = "Fabric"
        static let userPreference = "UserPreference"
        static let fabricRecommendation = "FabricRecommendation"
        static let profile = "Profile"
    }
    
    // MARK: - Questionnaire
    struct Questionnaire {
        static let minTemperature: Double = -10
        static let maxTemperature: Double = 50
    }
    
    // MARK: - Error Messages
    struct ErrorMessages {
        static let genericError = "An unexpected error occurred. Please try again."
        static let dataLoadError = "Failed to load data. Please check your connection and try again."
        static let dataSaveError = "Failed to save data. Please try again."
    }
}
