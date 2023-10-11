## A code study examining working with SwiftUI Lists that have 1,000,000+ CoreData entries

### Goals achieved:
- Display lists with more than 1,000,000 items stored in CoreData
- Sort large lists within a reasonable amount of time
- Insert list items without noticable delay
- Remove list items without noticable delay
- Update list items from within a cell and from outside of the cell without noticable delay and without loosing scroll position
- Never lock up the UI and show an activity indicator when tasks are not instant (e.g. when sorting the user can still scroll the list and sees an activity indicator)

### Compromises made:
- Lists with more than 100 items loose scroll position when deleting or adding cells
- List changes are not animated