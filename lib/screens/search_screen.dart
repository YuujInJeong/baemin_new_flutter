import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../repositories/mock_data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        title: Semantics(
          label: '메뉴 검색 입력창',
          hint: '오늘은 무엇을 드실건가요? 두번탭하면 메뉴가 검색됩니다.',
          textField: true,
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: '오늘은 무엇을 드실건가요?',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: AppTheme.textGray),
            ),
            style: const TextStyle(fontSize: 16),
            onTap: () {
              // 두번 탭하면 검색 실행
            },
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Semantics(
            label: '섹션 제목',
            child: const Text(
              '인기 검색어',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textBlack,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...MockData.popularSearches.map((search) {
            return _buildSearchItem(
              rank: search['rank'] as int,
              keyword: search['keyword'] as String,
              change: search['change'] as int,
              isNew: search['isNew'] as bool,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSearchItem({
    required int rank,
    required String keyword,
    required int change,
    required bool isNew,
  }) {
    Widget changeWidget;
    String changeLabel = '';
    String changeHint = '';
    
    if (isNew) {
      changeWidget = Semantics(
        label: '신규 배지',
        hint: '이번 주 새로 등장한 검색어입니다.',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'N',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      changeLabel = '신규 검색어';
      changeHint = '이번 주 새로 등장한 검색어입니다.';
    } else if (change > 0) {
      changeWidget = Semantics(
        label: '순위 상승',
        hint: '지난 주 대비 $change위 상승했습니다.',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: '상승 아이콘',
              image: true,
              child: const Icon(Icons.arrow_upward, size: 14, color: Colors.red),
            ),
            Text(
              '$change',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
      );
      changeLabel = '순위 상승 $change위';
      changeHint = '지난 주 대비 $change위 상승했습니다.';
    } else if (change < 0) {
      changeWidget = Semantics(
        label: '순위 하락',
        hint: '지난 주 대비 ${change.abs()}위 하락했습니다.',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: '하락 아이콘',
              image: true,
              child: const Icon(Icons.arrow_downward, size: 14, color: Colors.blue),
            ),
            Text(
              '${change.abs()}',
              style: const TextStyle(color: Colors.blue, fontSize: 12),
            ),
          ],
        ),
      );
      changeLabel = '순위 하락 ${change.abs()}위';
      changeHint = '지난 주 대비 ${change.abs()}위 하락했습니다.';
    } else {
      changeWidget = Semantics(
        label: '순위 유지',
        hint: '지난 주와 동일한 순위입니다.',
        child: const Text(
          '-',
          style: TextStyle(color: AppTheme.textGray, fontSize: 12),
        ),
      );
      changeLabel = '순위 변동 없음';
      changeHint = '지난 주와 동일한 순위입니다.';
    }

    return Semantics(
      label: '$rank위 인기 검색어: $keyword',
      hint: '$changeLabel. $changeHint. 누르시면 $keyword 검색 결과 화면으로 이동합니다.',
      button: true,
      child: GestureDetector(
        onTap: () {
          // 검색 결과 화면으로 이동
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Semantics(
                label: '검색어 순위',
                child: SizedBox(
                  width: 30,
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textBlack,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Semantics(
                  label: '검색어',
                  child: Text(
                    keyword,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textBlack,
                    ),
                  ),
                ),
              ),
              changeWidget,
            ],
          ),
        ),
      ),
    );
  }
}
