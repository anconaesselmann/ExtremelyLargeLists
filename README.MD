## A code study examining working with SwiftUI Lists that have 1,000,000+ CoreData entries

### Note
- To generating large random lists inspect ExtremelyLargeListsApp's initializer
- The app prints the core data store location to the console. Delete `Items`, `Items.sqlite-shm` and `Items.sqlite-wal` to reset the store

### Goals achieved:
- Display lists with more than 1,000,000 items stored in CoreData
- Sort large lists within a reasonable amount of time
- Insert list items without noticeable delay
- Remove list items without noticeable delay
- Update list items from within a cell and from outside of the cell without noticeable delay and without loosing scroll position
- Never lock up the UI and show an activity indicator when tasks are not instantaneous (e.g. when sorting, the user can still scroll the list and sees an activity indicator)
- Maintain selected list item when sorting

### Compromises made:
- Lists with large amount of items loose scroll position when deleting or adding cells
- List changes are not animated

### TODO:
- [ ] The problem was worked on MacOS. Replace the HSplitView with something comparable for iOS
- [ ] Delete items in large lists without loosing scroll position
