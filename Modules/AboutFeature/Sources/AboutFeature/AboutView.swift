import SwiftUI

public struct AboutView: View {
    private let name = "Fahmi"
    private let role = "iOS Developer"
    private let bio = "iOS developer focused on building clean, well-tested iOS apps."
    private let email = "fhmsyhd@gmail.com.com"
    private let github = "github.com/fhmsyhd"
    private let linkedin = "linkedin.com/in/fhmsyhd"

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                profileImage
                    .padding(.top, 24)

                VStack(spacing: 4) {
                    Text(name)
                        .font(.title2.bold())
                    Text(role)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(bio)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 32)

                VStack(spacing: 0) {
                    contactRow(icon: "envelope.fill", label: "Email", value: email)
                    Divider().padding(.leading, 52)
                    contactRow(icon: "link", label: "GitHub", value: github)
                    Divider().padding(.leading, 52)
                    contactRow(icon: "person.crop.circle.fill", label: "LinkedIn", value: linkedin)
                }
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 16)

                Text("Movie data provided by The Movie Database (TMDB).")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private var profileImage: some View {
        Group {
            if let uiImage = UIImage(named: "ProfilePhoto") {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ZStack {
                    Circle().fill(Color.accentColor.opacity(0.15))
                    Image(systemName: "person.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(Color.accentColor)
                }
            }
        }
        .frame(width: 120, height: 120)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
    }

    private func contactRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color.accentColor)
                .frame(width: 24)
            Text(label)
                .font(.subheadline)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
