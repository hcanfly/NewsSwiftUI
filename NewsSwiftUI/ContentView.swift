//
//  ContentView.swift
//  News-SwiftUI
//
//  Created by Gary Hanson on 6/12/21.
//

import SwiftUI


enum DataLoadingState {
    case ready
    case loading
}

struct ContentView: View {
    @State var newsStories: NewsStories
    @State var storiesCategory: HeadlineCategory
    @State var loadingState = DataLoadingState.ready
    
    var body: some View {
        NavigationView {
            storiesView()
        }
    }
    
    fileprivate func storiesView() -> some View {
        return List {
            ForEach(newsStories.stories, id: \.url) { story in
                NavigationLink(destination: WebView(urlString: story.url)) {
                    HStack(spacing: 0) {
                        CachedAsyncImageView(url: URL(string: story.urlToImage ?? ""))
                            .frame(width: 160, height: 90)
                            .clipped()
                            .padding(.trailing, 4)
                        Text(story.title ?? "")
                            .font(.system(size: 14.0))
                            .frame(height: 90)
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 2, bottom: 2, trailing: 2))
                }
            }
            .listRowBackground(Color.gray)
        }
        .listStyle(GroupedListStyle())  // this lets List fill entire width
        .refreshable {
            if self.loadingState == .ready {
                await loadDatawithState()
           }
        }
        .task {
            await loadDatawithState()
        }
        .navigationTitle(storiesCategory.rawValue)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(HeadlineCategory.top.rawValue) {
                    storiesCategory = .top
                    async {
                        await loadDatawithState()
                    }
                }
                .disabled(loadingState != .ready || storiesCategory == .top)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(HeadlineCategory.sports.rawValue) {
                    storiesCategory = .sports
                    async {
                        await loadDatawithState()
                    }
                }
                .disabled(loadingState != .ready || storiesCategory == .sports)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(HeadlineCategory.tech.rawValue) {
                    storiesCategory = .tech
                    async {
                        await loadDatawithState()
                    }
                }
                .disabled(loadingState != .ready || storiesCategory == .tech)
            }
        }
    }
    
    fileprivate func loadDatawithState() async {
            self.loadingState = .loading
            await loadData()
            self.loadingState = .ready
    }
    
    fileprivate func loadData() async {
        do {
            try await newsStories = NetworkData.fetch(category: self.storiesCategory, myType: NewsStories.self)
        } catch {
            print(error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(newsStories: NewsStories(), storiesCategory: .sports)
    }
}
