//
//  ContentView.swift
//  Learning1
//
//  Created by Mazen Idriss on 9/28/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentIndex = 0
    @State private var gutHealthAnswer: String? = nil
    @State private var bathroomAnswer: String? = nil
    
    var body: some View {
        TabView(selection: $currentIndex) {
            WelcomeSlide()
                .tag(0)
            
            HowItWorksSlide()
                .tag(1)
            
            GutHealthQuestionSlide(
                selectedOption: $gutHealthAnswer,
                onAnswered: {
                    withAnimation { currentIndex = 3 }
                }
            )
            .tag(2)
            
            ResponseSlide(
                answer: gutHealthAnswer,
                onFinished: {
                    withAnimation { currentIndex = 4 }
                }
            )
            .tag(3)
            
            BathroomRoutineSlide(
                selectedOption: $bathroomAnswer,
                onAnswered: {
                    withAnimation { currentIndex = 5 }
                }
            )
            .tag(4)
            
            ResponseSlide(
                answer: bathroomAnswer,
                onFinished: {
                    withAnimation { currentIndex = 6 }
                }
            )
            .tag(5)
            
            // Now we move forward after both responses
            LoginView()
                .tag(6)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.green)
                .ignoresSafeArea()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(.easeInOut, value: currentIndex)
        .ignoresSafeArea()
    }
}





struct WelcomeSlide: View {
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 30) {
                Spacer()
                
                Text("💩")
                    .font(.system(size: 100))
                
                Text("Welcome to Turdly")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Track your health with a smile.\nAI-powered stool analysis made simple.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 30)
                
                Spacer()
            }
        }
    }
}

struct HowItWorksSlide: View {
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 30) {
                Text("How Turdly Works")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                VStack(spacing: 20) {
                    HowItWorksStep(icon: "camera", text: "Snap a photo after each visit")
                    HowItWorksStep(icon: "brain.head.profile", text: "AI analyzes stool health automatically")
                    HowItWorksStep(icon: "chart.bar", text: "Track trends and get health insights")
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
    }
}

struct GutHealthQuestionSlide: View {
    @Binding var selectedOption: String?
    var onAnswered: () -> Void
    
    let options: [SurveyOption] = [
        SurveyOption(text: "I’m a well-oiled machine", icon: "💪"),
        SurveyOption(text: "Okay – could be better", icon: "🤏"),
        SurveyOption(text: "Poor – I struggle with gut issues", icon: "😵‍💫")
    ]
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 40) {
                Text("How do you feel about your gut health?")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
                
                VStack(spacing: 20) {
                    ForEach(options) { option in
                        Button(action: {
                            withAnimation {
                                selectedOption = option.text
                                onAnswered() // <-- tell parent to move forward
                            }
                        }) {
                            HStack(spacing: 20) {
                                ZStack {
                                    Circle()
                                        .fill(selectedOption == option.text ? Color.white : Color.white.opacity(0.2))
                                        .frame(width: 50, height: 50)
                                    Text(option.icon)
                                        .font(.title2)
                                }
                                
                                Text(option.text)
                                    .font(.headline)
                                    .foregroundColor(selectedOption == option.text ? .white : .white.opacity(0.9))
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(selectedOption == option.text ? Color.white.opacity(0.3) : Color.white.opacity(0.15))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(selectedOption == option.text ? Color.white : Color.clear, lineWidth: 2)
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        }
                        .scaleEffect(selectedOption == option.text ? 1.05 : 1.0)
                        .animation(.spring(), value: selectedOption)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
    }
}

struct ResponseSlide: View {
    let answer: String?
    var onFinished: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 30) {
                Spacer()
                
                if let answer = answer {
                    // Gut health responses
                    if answer.contains("well-oiled") {
                        ResponseContent(
                            emoji: "💪",
                            message: "Awesome! Keep up the great gut health."
                        )
                    } else if answer.contains("Okay") {
                        ResponseContent(
                            emoji: "🤏",
                            message: "Not bad! We’ll help you improve step by step."
                        )
                    } else if answer.contains("Poor") {
                        ResponseContent(
                            emoji: "😵‍💫",
                            message: "No worries. Turdly will guide you to better gut health."
                        )
                    }
                    // Bathroom routine responses
                    else if answer.contains("clockwork") {
                        ResponseContent(
                            emoji: "🕒",
                            message: "Nice! Consistency is king 👑."
                        )
                    } else if answer.contains("over the place") {
                        ResponseContent(
                            emoji: "🎢",
                            message: "We’ll help smooth things out 🧻."
                        )
                    } else if answer.contains("avoid talking") {
                        ResponseContent(
                            emoji: "🙈",
                            message: "Fair enough! Turdly keeps things private 🤫."
                        )
                    }
                    // Fallback
                    else {
                        ResponseContent(
                            emoji: "🤔",
                            message: "Interesting choice!"
                        )
                    }
                } else {
                    ResponseContent(
                        emoji: "❓",
                        message: "Choose an option first!"
                    )
                }
                
                Spacer()
            }
            .scaleEffect(animate ? 1.0 : 0.7)
            .opacity(animate ? 1.0 : 0.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.6), value: animate)
        }
        .onAppear {
            animate = true
            // Auto-advance after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                onFinished()
            }
        }
    }
}


/// Helper view for the response
struct ResponseContent: View {
    let emoji: String
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text(emoji)
                .font(.system(size: 100))
            
            Text(message)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal, 30)
        }
    }
}


/// Shared gradient background
struct GradientBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [.orange, .yellow]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea() // <--- makes it full screen everywhere
    }
}

struct HowItWorksStep: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 50, height: 50)
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
            }

            Text(text)
                .foregroundColor(.white)
                .font(.title3)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(16)
    }
}

struct BathroomRoutineSlide: View {
    @Binding var selectedOption: String?
    var onAnswered: () -> Void
    
    let options: [SurveyOption] = [
        SurveyOption(text: "Like clockwork", icon: "🕒"),
        SurveyOption(text: "All over the place", icon: "🎢"),
        SurveyOption(text: "I avoid talking about it", icon: "🙈")
    ]
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 40) {
                Text("How’s your bathroom routine?")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
                
                VStack(spacing: 20) {
                    ForEach(options) { option in
                        Button(action: {
                            withAnimation {
                                selectedOption = option.text
                                onAnswered()
                            }
                        }) {
                            HStack(spacing: 20) {
                                ZStack {
                                    Circle()
                                        .fill(selectedOption == option.text ? Color.white : Color.white.opacity(0.2))
                                        .frame(width: 50, height: 50)
                                    Text(option.icon)
                                        .font(.title2)
                                }
                                
                                Text(option.text)
                                    .font(.headline)
                                    .foregroundColor(selectedOption == option.text ? .white : .white.opacity(0.9))
                                
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(selectedOption == option.text ? Color.white.opacity(0.3) : Color.white.opacity(0.15))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(selectedOption == option.text ? Color.white : Color.clear, lineWidth: 2)
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        }
                        .scaleEffect(selectedOption == option.text ? 1.05 : 1.0)
                        .animation(.spring(), value: selectedOption)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
    }
}


struct SurveyOption: Identifiable {
    let id = UUID()
    let text: String
    let icon: String
}

#Preview {
    OnboardingView()
}
