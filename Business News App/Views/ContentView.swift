//
//  ContentView.swift
//  Business News App
//
//  Created by Vy Dang Phuong Nguyen on 11/27/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var articles = [Article]()

    var body: some View {
      
        NavigationView {
            ZStack {
                
                Color.black
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    
                    Text("Headlines")
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                        .bold()
                        .padding(.leading, 20)
                        .padding(.top, 30)
                    
                    Text("Mentioning Apple")
                        .foregroundColor(.gray)
                        .padding(.leading, 20)
                    
                    ScrollView {
                        
                        LazyVStack(alignment: .leading) {
                            
                            ForEach(articles, id: \.self) { article in
                                
                                NavigationLink(
                                    destination: WebView(url: URL(string: article.url!)!),
                                    label: {
                                        HStack(alignment: .top) {
                                            
                                            ImageView(url: URL(string: article.urlToImage!)!)
                                                .scaledToFill()
                                                .frame(width: 150, height: 150)
                                                .clipped()
                                                .cornerRadius(10)
                                                .padding(.bottom, 20)
                                            
                                            VStack(alignment: .leading) {
                                                
                                                Text(article.title!)
                                                    .multilineTextAlignment(.leading)
                                                    .bold()
                                                    .foregroundColor(Color.white)
                                                
                                                // Spacer()
                                                
                                                Text("By \(article.author!)")
                                                    .padding(.top, 2)
                                                    .foregroundColor(Color.gray)
                                                    .multilineTextAlignment(.leading)
                                                    .bold()
                                                
                                                //Spacer()
                                            }
                                            .padding(10)
                                        }
                                    })
                            }
                        }
                        .accentColor(Color.black)
                        .padding(17)
                    }
                    
                }
            }
        }
        .task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        
        // TechCrunch headlines
        /*
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=bcf851953bbb43b9b8cb414e79e4932a") else {
            print("Invalid URL")
            return
        }
        */
        
        // Apple headlines
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=apple&from=2022-11-26&to=2022-11-26&sortBy=popularity&apiKey=bcf851953bbb43b9b8cb414e79e4932a") else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let news = try? JSONDecoder().decode(News.self, from: data) {
                self.articles = news.articles!
            }
        }
        catch {
            print("Cannot parse JSON")
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
