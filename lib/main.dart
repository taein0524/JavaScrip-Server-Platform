import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 선택된 이모지
  List<String> selectedEmojis = [];

  // 댓글
  final TextEditingController commentController = TextEditingController();

  List<String> comments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(CupertinoIcons.bars, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.search, color: Colors.black),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.mail, color: Colors.black),
          ),
        ],
        title: const Text("게시판"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 게시물 이미지
            Image.network(
              "https://picsum.photos/id/1015/600/400",
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            // 버튼 영역 (Chat GPT 활용)
            Row(
              children: [
                // 😀 이모지 버튼
                IconButton(
                  onPressed: showEmojiPicker,
                  icon: const Text("😀", style: TextStyle(fontSize: 28)),
                ),

                // 댓글
                IconButton(
                  onPressed: showCommentSheet,
                  icon: const Icon(CupertinoIcons.chat_bubble),
                ),

                // 공유
                IconButton(
                  onPressed: showShareDialog,
                  icon: const Icon(CupertinoIcons.arrowshape_turn_up_right),
                ),

                const Spacer(),

                IconButton(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.bookmark),
                ),
              ],
            ),

            // 선택된 이모지들 (Chat GPT 활용)
            if (selectedEmojis.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedEmojis.map((emoji) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(emoji, style: const TextStyle(fontSize: 28)),
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "댓글 ${comments.length}개",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 8),

            ...comments.map(
              (comment) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Text("• $comment"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================
  // 이모지 선택 (Chat GPT 활용)
  // ==========================
  void showEmojiPicker() {
    final emojis = ["😀", "😂", "😍", "😎", "🔥", "❤️", "👍", "🎉"];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 180,
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
            ),
            itemCount: emojis.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedEmojis.add(emojis[index]);
                  });

                  Navigator.pop(context);
                },
                child: Center(
                  child: Text(
                    emojis[index],
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ==========================
  // 공유 URL (Chat GPT 활용)
  // ==========================
  void showShareDialog() {
    const url = "https://myapp.com/post/1";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("공유 URL"),
          content: const SelectableText(url),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("닫기"),
            ),
          ],
        );
      },
    );
  }

  // ==========================
  // 댓글창 (Chat GPT 활용)
  // ==========================
  void showCommentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setBottomState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: 500,
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    const Text(
                      "댓글",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Divider(),

                    Expanded(
                      child: comments.isEmpty
                          ? const Center(child: Text("댓글이 없습니다."))
                          : ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                  title: Text(comments[index]),

                                  // 길게 눌러 삭제
                                  onLongPress: () {
                                    showDeleteDialog(index, setBottomState);
                                  },
                                );
                              },
                            ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentController,
                              decoration: const InputDecoration(
                                hintText: "댓글 입력...",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              if (commentController.text.trim().isEmpty) {
                                return;
                              }

                              setState(() {
                                comments.add(commentController.text);
                              });

                              setBottomState(() {});

                              commentController.clear();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==========================
  // 댓글 삭제 (Chat GPT 활용)
  // ==========================
  void showDeleteDialog(int index, StateSetter setBottomState) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("댓글 삭제"),
          content: const Text("이 댓글을 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  comments.removeAt(index);
                });

                setBottomState(() {});

                Navigator.pop(context);
              },
              child: const Text("삭제"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}
