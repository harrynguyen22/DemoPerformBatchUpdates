# DemoPerformBatchUpdates

In this demo, we'll do an experiment about `UICollectionView.performBatchUpdates()` func. We'll try 2 ways to implement this func
1. Remove element at **index (1) 3 times** in data source and also in collection view
2. Remove element at **index (3) (2) (1)** in data source and in collection view

Try it yourself by these actions:
- Tap **Wrong Action** button to try **action (1)**
- Tap **Correct Action** button to try **action (2)**
- Remember to **Reset** after each action.

So some **sequences** you can try:
1. Wrong Action => Reset => Correct Action
2. Wrong Action => Reset => Wrong Action => ... (Loop)
3. Correct Action => Reset => Correct Action => ... (Loop)

Some **behaviors** can be observed according to each sequence
1. **Sequence 1:** Wrong Action shows wrong UI, Correct Action shows correct UI
2. **Sequence 2:** App crashes, exception raises at the 2nd or 3rd loop.
3. **Sequence 3:** Correct UI, app works well.
