import relationalStore from '@ohos.data.relationalStore';
import preferences from '@ohos.data.preferences';
import { NewsBean } from '../mode/NewsBean';
import { Users } from '../mode/Users';
import { Comment } from '../mode/Comment';
import { CollectBean } from '../mode/CollectBean';
import { CommentItem } from '../mode/CommentItem';

export default class RdbUtils {
  private static rdbStore: relationalStore.RdbStore;
  static dataPreferences: preferences.Preferences | null = null;

  static setStore(store: relationalStore.RdbStore) {
    RdbUtils.rdbStore = store;
    //创建数据库表
    const NEWS_TABLE = 'CREATE TABLE IF NOT EXISTS NEWS (ID INTEGER PRIMARY KEY AUTOINCREMENT, IMAGE TEXT NOT NULL,TITLE TEXT NOT NULL,MDESC BLOB,TYPE INTEGER,TIME TEXT NOT NULL)';
    const USERS_TABLE = 'CREATE TABLE IF NOT EXISTS USERS (ID INTEGER PRIMARY KEY AUTOINCREMENT, ACCOUNT TEXT NOT NULL, PASSWORD TEXT NOT NULL, AVATAR TEXT)';
    const COMMENT_TABLE = 'CREATE TABLE IF NOT EXISTS COMMENT (ID INTEGER PRIMARY KEY AUTOINCREMENT, HEAD TEXT NOT NULL,USERNAME TEXT NOT NULL,MDESC BLOB,NID INTEGER,TIME TEXT NOT NULL)';
    const COLLECT_TABLE = 'CREATE TABLE IF NOT EXISTS COLLECT (ID INTEGER PRIMARY KEY AUTOINCREMENT, USERNAME TEXT NOT NULL,NID INTEGER,TIME TEXT NOT NULL)';

    this.executeSql(NEWS_TABLE);
    this.executeSql(USERS_TABLE);
    this.executeSql(COMMENT_TABLE);
    this.executeSql(COLLECT_TABLE);

    // 检查并升级数据库
    this.upgradeDatabaseIfNeeded().then(() => {
      this.initData(); //初始化新闻数据
    });
  }

  // 添加数据库升级检查
  static async upgradeDatabaseIfNeeded(): Promise<void> {
    try {
      console.info("Checking database structure...");

      // 检查 USERS 表是否有 AVATAR 列
      const result = await this.getStore().querySql("PRAGMA table_info(USERS)");
      let hasAvatarColumn = false;
      let columns = [];

      while (result.goToNextRow()) {
        const columnName = result.getString(result.getColumnIndex('name'));
        const columnType = result.getString(result.getColumnIndex('type'));
        columns.push(`${columnName} (${columnType})`);

        if (columnName === 'AVATAR') {
          hasAvatarColumn = true;
        }
      }

      console.info("Current USERS table columns: " + columns.join(', '));

      if (!hasAvatarColumn) {
        console.info("Adding AVATAR column to USERS table...");
        await this.executeSql('ALTER TABLE USERS ADD COLUMN AVATAR TEXT');
        console.info("Successfully added AVATAR column");
      } else {
        console.info("AVATAR column already exists");
      }

    } catch (error) {
      console.error("Database upgrade failed: " + error);
    }
  }

  // 添加调试方法查看用户表内容
  static async debugUsersTable(): Promise<void> {
    try {
      console.info("=== DEBUG: USERS TABLE CONTENTS ===");
      const result = await this.getStore().querySql("SELECT * FROM USERS");
      let rowCount = 0;
      while (result.goToNextRow()) {
        rowCount++;
        const id = result.getLong(result.getColumnIndex('ID'));
        const account = result.getString(result.getColumnIndex('ACCOUNT'));
        const password = result.getString(result.getColumnIndex('PASSWORD'));
        let avatar = '';
        try {
          avatar = result.getString(result.getColumnIndex('AVATAR')) || '';
        } catch (e) {
          avatar = 'NOT_FOUND';
        }
        console.info(`User ${rowCount}: ID=${id}, ACCOUNT=${account}, PASSWORD=${password}, AVATAR=${avatar}`);
      }
      console.info(`Total users: ${rowCount}`);
      console.info("=== DEBUG END ===");
    } catch (error) {
      console.error("Debug query failed: " + error);
    }
  }

  // 添加更新用户头像的方法
  static async updateUserAvatar(account: string, avatarPath: string): Promise<number> {
    let predicates = new relationalStore.RdbPredicates('USERS');
    predicates.equalTo("account", account);

    const valueBucket = {
      "AVATAR": avatarPath
    };

    return RdbUtils.getStore().update(valueBucket, predicates);
  }

  // 添加获取用户头像的方法
  static async getUserAvatar(account: string): Promise<string> {
    let predicates = new relationalStore.RdbPredicates('USERS');
    predicates.equalTo("account", account);

    return new Promise<string>((resolve, reject) => {
      RdbUtils.getStore().query(predicates).then((result) => {
        let avatar = '';
        while (result.goToNextRow()) {
          // 获取 AVATAR 字段，如果不存在则返回空字符串
          try {
            avatar = result.getString(result.getColumnIndex('AVATAR')) || '';
          } catch (e) {
            avatar = '';
          }
        }
        resolve(avatar);
      }).catch((error) => {
        reject(error);
      });
    });
  }

  static setPreferences(dataPreferences: preferences.Preferences) {
    RdbUtils.dataPreferences = dataPreferences;
  }

  static initData() {
    const valueBucket = [
      {
        'IMAGE': '2.png',
        'TITLE': '通车30年，全国最繁忙的高速公路之一，决定停止收费！',
        'MDESC': '这是测试数据1',
        'TYPE': 0,
        'TIME': '06-15'
      },
      {
        'IMAGE': '3.png',
        'TITLE': '夫妻生活的最高境界：四个字',
        'MDESC': '这是测试数据2',
        'TYPE': 0,
        'TIME': '06-15'
      },
      {
        'IMAGE': '4.png',
        'TITLE': '有颜有实力！铁人三项女运动员冯竟爽，因颜值和身材受关注',
        'MDESC': '这是测试数据3',
        'TYPE': 0,
        'TIME': '06-15'
      },
      {
        'IMAGE': '5.png',
        'TITLE': '中国第一条高速磁悬浮呼之欲出：时速600公里以上 陆地最快交通',
        'MDESC': '这是测试数据4',
        'TYPE': 0,
        'TIME': '06-15'
      },
      {
        'IMAGE': '6.png',
        'TITLE': '一觉醒来，东部战区兵分5路包围台湾岛，美日进不来台独跑不了',
        'MDESC': '这是测试数据5',
        'TYPE': 0,
        'TIME': '06-15'
      },
      {
        'IMAGE': '7.png',
        'TITLE': '东部战区持续位台岛以东海空域 开展舰机协同、对海突击、对陆打击等科目训练',
        'MDESC': '这是测试数据6',
        'TYPE': 0,
        'TIME': '06-15'
      },
      {
        'IMAGE': '8.png',
        'TITLE': '年轻人想躺平、害怕卷，有啥建议？董明珠这样回答',
        'MDESC': '这是测试数据7',
        'TYPE': 7,
        'TIME': '06-15'
      },
      {
        'IMAGE': '9.png',
        'TITLE': '2010年，广东打工妹嫁比利时王子成为王妃, 如今风光回国探亲',
        'MDESC': '这是测试数据8',
        'TYPE': 0,
        'TIME': '06-15'
      },
      {
        'IMAGE': '10.png',
        'TITLE': '我大使警告日本勿插手台海，否则将自身难保，日方：中方言论不妥',
        'MDESC': '这是测试数据9',
        'TYPE': 0,
        'TIME': '06-15'
      },
      {
        'IMAGE': '11.png',
        'TITLE': '谁敢与中国谈和？马科斯打响首枪，菲军司令被清算，前总统也被查',
        'MDESC': '这是测试数据9',
        'TYPE': 5,
        'TIME': '06-15'
      },
      {
        'IMAGE': '12.png',
        'TITLE': '退休后，如果你一个朋友都没有，看看李叔同的五句话，就活通透了',
        'MDESC': '这是测试数据9',
        'TYPE': 4,
        'TIME': '06-15'
      },
      {
        'IMAGE': '16.png',
        'TITLE': '四川一县委原书记女儿在北京买房，商人直接拿出1000万元',
        'MDESC': '这是测试数据9',
        'TYPE': 1,
        'TIME': '06-15'
      },
      {
        'IMAGE': '13.png',
        'TITLE': '望岳谈｜四部门住房“组合拳”：让商品房流动起来',
        'MDESC': '这是测试数据9',
        'TYPE': 2,
        'TIME': '06-15'
      },
      {
        'IMAGE': '14.png',
        'TITLE': '变废地为新绿 生态修复换来“金山银山”',
        'MDESC': '这是测试数据9',
        'TYPE': 3,
        'TIME': '06-15'
      },
      {
        'IMAGE': '15.png',
        'TITLE': '至今未娶妻的几位大龄男星，最大94岁，最小52岁，各有各的苦衷',
        'MDESC': '这是测试数据9',
        'TYPE': 6,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's1.png',
        'TITLE': '网传低价购机票“时点攻略”靠谱吗',
        'MDESC': '距离暑假还有一个月的时间，各大旅行社、旅游平台已经进入“战备阶段”。6月中旬，“毕业游”“亲子游”需求逐步走高，民航业将迎来暑运出行高峰，暑假机票预订量同比增长约1.1倍。由于机票价格变动较大，如何能“卡时段”买到低价票成为热点...',
        'TYPE': 1,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's2.png',
        'TITLE': '“港珠澳大桥游”开通半年 游客已达14.9万人次',
        'MDESC': '这是测试数据9',
        'TYPE': 1,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's3.png',
        'TITLE': '宁波一上市公司因被要求补缴5亿税款宣布停产？当地税务部门回应',
        'MDESC': '这是测试数据9',
        'TYPE': 1,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's4.png',
        'TITLE': '水位上涨 广西部分河段实施水上交通管制',
        'MDESC': '这是测试数据9',
        'TYPE': 1,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's5.png',
        'TITLE': '今夏高温天气会频现吗？专家释疑本轮北方高温热点问题',
        'MDESC': '这是测试数据9',
        'TYPE': 1,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's6.png',
        'TITLE': '北京地铁3号线一期预计年内开通 空载试运行抢先看→',
        'MDESC': '这是测试数据9',
        'TYPE': 1,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's7.png',
        'TITLE': '为什么近期南方持续强降雨 北方高温不退？',
        'MDESC': '这是测试数据9',
        'TYPE': 1,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '和狗狗们“包机”旅行回来啦！国内首架携宠出境包机返沪',
        'MDESC': '这是测试数据9',
        'TYPE': 1,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '开创我国高质量发展新局面',
        'MDESC': '这是测试数据9',
        'TYPE': 9,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '父子情 公仆心',
        'MDESC': '这是测试数据9',
        'TYPE': 9,
        'TIME': '06-15'
      }, {
      'IMAGE': 's8.png',
      'TITLE': '仅23秒！欧洲杯历史最快进球诞生',
      'MDESC': '这是测试数据9',
      'TYPE': 9,
      'TIME': '06-15'
    }, {
      'IMAGE': 's8.png',
      'TITLE': '姜萍为啥没读高中？初中老师回应',
      'MDESC': '这是测试数据9',
      'TYPE': 9,
      'TIME': '06-15'
    }, {
      'IMAGE': 's8.png',
      'TITLE': '父亲节前爸爸捐骨髓救人:教儿子感恩',
      'MDESC': '这是测试数据9',
      'TYPE': 9,
      'TIME': '06-15'
    },
      {
        'IMAGE': 's8.png',
        'TITLE': '大学生39天减重近20斤后猝死',
        'MDESC': '这是测试数据9',
        'TYPE': 9,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '传南方医大老师因救人上课迟到被罚',
        'MDESC': '这是测试数据9',
        'TYPE': 9,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '“复兴号”车厢转运时被货车撞上',
        'MDESC': '这是测试数据9',
        'TYPE': 9,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '女生爬山遇毒蛇竟凑上前合影',
        'MDESC': '这是测试数据9',
        'TYPE': 9,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '为什么建议夏天多吃面',
        'MDESC': '这是测试数据9',
        'TYPE': 9,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '雌激素降低确实会催人老',
        'MDESC': '这是测试数据9',
        'TYPE': 9,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '桂林暴雨被水冲走的初中生已遇难',
        'MDESC': '这是测试数据9',
        'TYPE': 9,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '10元手冲咖啡阿姨回应不火了',
        'MDESC': '这是测试数据9',
        'TYPE': 9,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '邓紫棋哭得差点唱不下去',
        'MDESC': '这是测试数据9',
        'TYPE': 9,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '女子乏力全家查出吸血鬼病基因',
        'MDESC': '这是测试数据9',
        'TYPE': 9,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '韩国人正在拒绝晋升',
        'MDESC': '这是测试数据9',
        'TYPE': 9,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '记者暗访广州假货市场',
        'MDESC': '这是测试数据9',
        'TYPE': 9,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '不必过度强调姜萍中专生身份',
        'MDESC': '这是测试数据9',
        'TYPE': 9,
        'TIME': '06-15'
      },
      {
        'IMAGE': '15.png',
        'TITLE': '至今未娶妻的几位大龄男星，最大94岁，最小52岁，各有各的苦衷',
        'MDESC': '这是测试数据9',
        'TYPE': 3,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's1.png',
        'TITLE': '网传低价购机票“时点攻略”靠谱吗',
        'MDESC': '距离暑假还有一个月的时间，各大旅行社、旅游平台已经进入“战备阶段”。6月中旬，“毕业游”“亲子游”需求逐步走高，民航业将迎来暑运出行高峰，暑假机票预订量同比增长约1.1倍。由于机票价格变动较大，如何能“卡时段”买到低价票成为热点...',
        'TYPE': 3,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's2.png',
        'TITLE': '“港珠澳大桥游”开通半年 游客已达14.9万人次',
        'MDESC': '这是测试数据9',
        'TYPE': 3,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's3.png',
        'TITLE': '宁波一上市公司因被要求补缴5亿税款宣布停产？当地税务部门回应',
        'MDESC': '这是测试数据9',
        'TYPE': 3,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's4.png',
        'TITLE': '水位上涨 广西部分河段实施水上交通管制',
        'MDESC': '这是测试数据9',
        'TYPE': 3,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's5.png',
        'TITLE': '今夏高温天气会频现吗？专家释疑本轮北方高温热点问题',
        'MDESC': '这是测试数据9',
        'TYPE': 3,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's6.png',
        'TITLE': '北京地铁3号线一期预计年内开通 空载试运行抢先看→',
        'MDESC': '这是测试数据9',
        'TYPE': 3,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's7.png',
        'TITLE': '为什么近期南方持续强降雨 北方高温不退？',
        'MDESC': '这是测试数据9',
        'TYPE': 3,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '和狗狗们“包机”旅行回来啦！国内首架携宠出境包机返沪',
        'MDESC': '这是测试数据9',
        'TYPE': 3,
        'TIME': '06-15'
      },
      {
        'IMAGE': '15.png',
        'TITLE': '至今未娶妻的几位大龄男星，最大94岁，最小52岁，各有各的苦衷',
        'MDESC': '这是测试数据9',
        'TYPE': 4,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's1.png',
        'TITLE': '网传低价购机票“时点攻略”靠谱吗',
        'MDESC': '距离暑假还有一个月的时间，各大旅行社、旅游平台已经进入“战备阶段”。6月中旬，“毕业游”“亲子游”需求逐步走高，民航业将迎来暑运出行高峰，暑假机票预订量同比增长约1.1倍。由于机票价格变动较大，如何能“卡时段”买到低价票成为热点...',
        'TYPE': 4,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's2.png',
        'TITLE': '“港珠澳大桥游”开通半年 游客已达14.9万人次',
        'MDESC': '这是测试数据9',
        'TYPE': 4,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's3.png',
        'TITLE': '宁波一上市公司因被要求补缴5亿税款宣布停产？当地税务部门回应',
        'MDESC': '这是测试数据9',
        'TYPE': 4,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's4.png',
        'TITLE': '水位上涨 广西部分河段实施水上交通管制',
        'MDESC': '这是测试数据9',
        'TYPE': 4,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's5.png',
        'TITLE': '今夏高温天气会频现吗？专家释疑本轮北方高温热点问题',
        'MDESC': '这是测试数据9',
        'TYPE': 4,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's6.png',
        'TITLE': '北京地铁3号线一期预计年内开通 空载试运行抢先看→',
        'MDESC': '这是测试数据9',
        'TYPE': 4,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's7.png',
        'TITLE': '为什么近期南方持续强降雨 北方高温不退？',
        'MDESC': '这是测试数据9',
        'TYPE': 4,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '和狗狗们“包机”旅行回来啦！国内首架携宠出境包机返沪',
        'MDESC': '这是测试数据9',
        'TYPE': 4,
        'TIME': '06-15'
      },
      {
        'IMAGE': '15.png',
        'TITLE': '至今未娶妻的几位大龄男星，最大94岁，最小52岁，各有各的苦衷',
        'MDESC': '这是测试数据9',
        'TYPE': 5,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's1.png',
        'TITLE': '网传低价购机票“时点攻略”靠谱吗',
        'MDESC': '距离暑假还有一个月的时间，各大旅行社、旅游平台已经进入“战备阶段”。6月中旬，“毕业游”“亲子游”需求逐步走高，民航业将迎来暑运出行高峰，暑假机票预订量同比增长约1.1倍。由于机票价格变动较大，如何能“卡时段”买到低价票成为热点...',
        'TYPE': 5,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's2.png',
        'TITLE': '“港珠澳大桥游”开通半年 游客已达14.9万人次',
        'MDESC': '这是测试数据9',
        'TYPE': 5,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's3.png',
        'TITLE': '宁波一上市公司因被要求补缴5亿税款宣布停产？当地税务部门回应',
        'MDESC': '这是测试数据9',
        'TYPE': 5,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's4.png',
        'TITLE': '水位上涨 广西部分河段实施水上交通管制',
        'MDESC': '这是测试数据9',
        'TYPE': 5,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's5.png',
        'TITLE': '今夏高温天气会频现吗？专家释疑本轮北方高温热点问题',
        'MDESC': '这是测试数据9',
        'TYPE': 5,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's6.png',
        'TITLE': '北京地铁3号线一期预计年内开通 空载试运行抢先看→',
        'MDESC': '这是测试数据9',
        'TYPE': 5,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's7.png',
        'TITLE': '为什么近期南方持续强降雨 北方高温不退？',
        'MDESC': '这是测试数据9',
        'TYPE': 5,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '和狗狗们“包机”旅行回来啦！国内首架携宠出境包机返沪',
        'MDESC': '这是测试数据9',
        'TYPE': 5,
        'TIME': '06-15'
      },
      {
        'IMAGE': '15.png',
        'TITLE': '至今未娶妻的几位大龄男星，最大94岁，最小52岁，各有各的苦衷',
        'MDESC': '这是测试数据9',
        'TYPE': 6,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's1.png',
        'TITLE': '网传低价购机票“时点攻略”靠谱吗',
        'MDESC': '距离暑假还有一个月的时间，各大旅行社、旅游平台已经进入“战备阶段”。6月中旬，“毕业游”“亲子游”需求逐步走高，民航业将迎来暑运出行高峰，暑假机票预订量同比增长约1.1倍。由于机票价格变动较大，如何能“卡时段”买到低价票成为热点...',
        'TYPE': 6,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's2.png',
        'TITLE': '“港珠澳大桥游”开通半年 游客已达14.9万人次',
        'MDESC': '这是测试数据9',
        'TYPE': 6,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's3.png',
        'TITLE': '宁波一上市公司因被要求补缴5亿税款宣布停产？当地税务部门回应',
        'MDESC': '这是测试数据9',
        'TYPE': 6,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's4.png',
        'TITLE': '水位上涨 广西部分河段实施水上交通管制',
        'MDESC': '这是测试数据9',
        'TYPE': 6,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's5.png',
        'TITLE': '今夏高温天气会频现吗？专家释疑本轮北方高温热点问题',
        'MDESC': '这是测试数据9',
        'TYPE': 6,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's6.png',
        'TITLE': '北京地铁3号线一期预计年内开通 空载试运行抢先看→',
        'MDESC': '这是测试数据9',
        'TYPE': 6,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's7.png',
        'TITLE': '为什么近期南方持续强降雨 北方高温不退？',
        'MDESC': '这是测试数据9',
        'TYPE': 6,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '和狗狗们“包机”旅行回来啦！国内首架携宠出境包机返沪',
        'MDESC': '这是测试数据9',
        'TYPE': 6,
        'TIME': '06-15'
      },
      {
        'IMAGE': '15.png',
        'TITLE': '至今未娶妻的几位大龄男星，最大94岁，最小52岁，各有各的苦衷',
        'MDESC': '这是测试数据9',
        'TYPE': 7,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's1.png',
        'TITLE': '网传低价购机票“时点攻略”靠谱吗',
        'MDESC': '距离暑假还有一个月的时间，各大旅行社、旅游平台已经进入“战备阶段”。6月中旬，“毕业游”“亲子游”需求逐步走高，民航业将迎来暑运出行高峰，暑假机票预订量同比增长约1.1倍。由于机票价格变动较大，如何能“卡时段”买到低价票成为热点...',
        'TYPE': 7,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's2.png',
        'TITLE': '“港珠澳大桥游”开通半年 游客已达14.9万人次',
        'MDESC': '这是测试数据9',
        'TYPE': 7,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's3.png',
        'TITLE': '宁波一上市公司因被要求补缴5亿税款宣布停产？当地税务部门回应',
        'MDESC': '这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9这是测试数据9',
        'TYPE': 7,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's4.png',
        'TITLE': '水位上涨 广西部分河段实施水上交通管制',
        'MDESC': '这是测试数据9',
        'TYPE': 7,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's5.png',
        'TITLE': '今夏高温天气会频现吗？专家释疑本轮北方高温热点问题',
        'MDESC': '这是测试数据9',
        'TYPE': 7,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's6.png',
        'TITLE': '北京地铁3号线一期预计年内开通 空载试运行抢先看→',
        'MDESC': '这是测试数据9',
        'TYPE': 7,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's7.png',
        'TITLE': '为什么近期南方持续强降雨 北方高温不退？',
        'MDESC': '这是测试数据9',
        'TYPE': 7,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '和狗狗们“包机”旅行回来啦！国内首架携宠出境包机返沪',
        'MDESC': '这是测试数据9',
        'TYPE': 7,
        'TIME': '06-15'
      },
      {
        'IMAGE': '15.png',
        'TITLE': '至今未娶妻的几位大龄男星，最大94岁，最小52岁，各有各的苦衷',
        'MDESC': '这是测试数据9',
        'TYPE': 2,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's1.png',
        'TITLE': '网传低价购机票“时点攻略”靠谱吗',
        'MDESC': '距离暑假还有一个月的时间，各大旅行社、旅游平台已经进入“战备阶段”。6月中旬，“毕业游”“亲子游”需求逐步走高，民航业将迎来暑运出行高峰，暑假机票预订量同比增长约1.1倍。由于机票价格变动较大，如何能“卡时段”买到低价票成为热点...',
        'TYPE': 2,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's2.png',
        'TITLE': '“港珠澳大桥游”开通半年 游客已达14.9万人次',
        'MDESC': '这是测试数据9',
        'TYPE': 2,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's3.png',
        'TITLE': '宁波一上市公司因被要求补缴5亿税款宣布停产？当地税务部门回应',
        'MDESC': '这是测试数据9',
        'TYPE': 2,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's4.png',
        'TITLE': '水位上涨 广西部分河段实施水上交通管制',
        'MDESC': '这是测试数据9',
        'TYPE': 2,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's5.png',
        'TITLE': '今夏高温天气会频现吗？专家释疑本轮北方高温热点问题',
        'MDESC': '这是测试数据9',
        'TYPE': 2,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's6.png',
        'TITLE': '北京地铁3号线一期预计年内开通 空载试运行抢先看→',
        'MDESC': '这是测试数据9',
        'TYPE': 2,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's7.png',
        'TITLE': '为什么近期南方持续强降雨 北方高温不退？',
        'MDESC': '这是测试数据9',
        'TYPE': 2,
        'TIME': '06-15'
      },
      {
        'IMAGE': 's8.png',
        'TITLE': '和狗狗们“包机”旅行回来啦！国内首架携宠出境包机返沪',
        'MDESC': '这是测试数据9',
        'TYPE': 2,
        'TIME': '06-15'
      }
    ];

    // 添加调试日志
    console.info("Initializing news data...");

    RdbUtils.insert('NEWS', valueBucket)
      .then((updateNumber) => {
        console.log('新闻数据插入成功:' + updateNumber)
      }).catch((error) => {
      console.log('新闻数据插入失败:' + error)
    })

  }

  static getStore(): relationalStore.RdbStore {
    return RdbUtils.rdbStore;
  }

  static executeSql(sql: string): Promise<void> {
    return RdbUtils.getStore().executeSql(sql);
  }

  static insert(tableName: string, data: any): Promise<number> {
    return RdbUtils.getStore().batchInsert(tableName, data);
  }

  static deleteCollect(account: string, nid: number): Promise<number> {
    let predicates = new relationalStore.RdbPredicates('COLLECT');
    predicates.equalTo('username', account)
    predicates.equalTo('nid', nid)
    return RdbUtils.getStore().delete(predicates);
  }
  static deleteComment(commentId: number): Promise<number> {
    let predicates = new relationalStore.RdbPredicates('COMMENT');
    predicates.equalTo('id', commentId);
    return RdbUtils.getStore().delete(predicates);
  }
  static insertOne(tableName: string, data: any): Promise<number> {
    return RdbUtils.getStore().insert(tableName, data);
  }

  // 添加用户注册方法
  static async registerUser(account: string, password: string): Promise<number> {
    console.info(`Registering user: ${account}`);

    const valueBucket = {
      'ACCOUNT': account,
      'PASSWORD': password,
      'AVATAR': '' // 初始为空字符串
    };

    return RdbUtils.insertOne('USERS', valueBucket);
  }

  static modifyPwd(username: string, pwd: string, data: any): Promise<number> {
    let predicates = new relationalStore.RdbPredicates('USERS');
    predicates.equalTo("account", username)
    predicates.equalTo("password", pwd)
    return RdbUtils.getStore().update(data, predicates)
  }

  static async queryByType(type: number): Promise<Array<NewsBean>> {
    let predicates = new relationalStore.RdbPredicates('NEWS');
    predicates.equalTo("type", type);
    return new Promise<Array<NewsBean>>((resolve, reject) => {
      RdbUtils.getStore().query(predicates).then((result) => {
        let newsList = new Array<NewsBean>();
        while (result.goToNextRow()) {
          let bean = new NewsBean(
            result.getLong(result.getColumnIndex('ID')),
            result.getString(result.getColumnIndex('IMAGE')),
            result.getString(result.getColumnIndex('TITLE')),
            result.getString(result.getColumnIndex('MDESC')),
            result.getLong(result.getColumnIndex('TYPE')),
            result.getString(result.getColumnIndex('TIME')),
          );
          newsList.push(bean);
        }
        resolve(newsList);
      }).catch((error) => {
        reject(error)
      })
    })
  }

  static async search(title: string): Promise<Array<NewsBean>> {
    let predicates = new relationalStore.RdbPredicates('NEWS');
    predicates.like("title", "%" + title + "%");
    return new Promise<Array<NewsBean>>((resolve, reject) => {
      RdbUtils.getStore().query(predicates).then((result) => {
        let newsList = new Array<NewsBean>();
        while (result.goToNextRow()) {
          let bean = new NewsBean(
            result.getLong(result.getColumnIndex('ID')),
            result.getString(result.getColumnIndex('IMAGE')),
            result.getString(result.getColumnIndex('TITLE')),
            result.getString(result.getColumnIndex('MDESC')),
            result.getLong(result.getColumnIndex('TYPE')),
            result.getString(result.getColumnIndex('TIME')),
          );
          newsList.push(bean);
        }
        resolve(newsList);
      }).catch((error) => {
        reject(error)
      })
    })
  }

  // 修复 queryUserByAccount 方法
  static async queryUserByAccount(account: string): Promise<Users> {
    let predicates = new relationalStore.RdbPredicates('USERS');
    predicates.equalTo("account", account);

    console.info(`Querying user by account: ${account}`);

    return new Promise<Users>((resolve, reject) => {
      RdbUtils.getStore().query(predicates).then((result) => {
        let bean: Users | undefined;

        // 先调试输出查询结果
        let rowCount = 0;
        while (result.goToNextRow()) {
          rowCount++;
          console.info(`Found user row ${rowCount}:`);

          // 使用 getColumnIndex 安全地获取列值
          try {
            const id = result.getLong(result.getColumnIndex('ID'));
            const accountVal = result.getString(result.getColumnIndex('ACCOUNT'));
            const password = result.getString(result.getColumnIndex('PASSWORD'));
            let avatar = '';

            // 安全地获取 AVATAR 列
            try {
              avatar = result.getString(result.getColumnIndex('AVATAR')) || '';
            } catch (e) {
              console.warn("AVATAR column not found or error: " + e);
              avatar = '';
            }

            console.info(`User data: ID=${id}, ACCOUNT=${accountVal}, PASSWORD=${password}, AVATAR=${avatar}`);

            bean = new Users(id, accountVal, password, avatar);
          } catch (error) {
            console.error("Error parsing user row: " + error);
          }
        }

        console.info(`Total rows found for account ${account}: ${rowCount}`);

        if (!bean) {
          console.info(`No user found for account: ${account}`);
        }

        resolve(bean);
      }).catch((error) => {
        console.error("Query user failed: " + error);
        reject(error);
      });
    });
  }

  static async queryNewsByID(id: number): Promise<NewsBean> {
    let predicates = new relationalStore.RdbPredicates('NEWS');
    predicates.equalTo("id", id);
    return new Promise<NewsBean>((resolve, reject) => {
      RdbUtils.getStore().query(predicates).then((result) => {
        let bean;
        while (result.goToNextRow()) {
          bean = new NewsBean(
            result.getLong(result.getColumnIndex('ID')),
            result.getString(result.getColumnIndex('IMAGE')),
            result.getString(result.getColumnIndex('TITLE')),
            result.getString(result.getColumnIndex('MDESC')),
            result.getLong(result.getColumnIndex('TYPE')),
            result.getString(result.getColumnIndex('TIME')),
          );
        }
        resolve(bean);
      }).catch((error) => {
        reject(error)
      })
    })
  }

  static async queryCommentByNewsID(nid: number): Promise<Array<Comment>> {
    let predicates = new relationalStore.RdbPredicates('COMMENT');
    predicates.equalTo("nid", nid);
    return new Promise<Array<Comment>>((resolve, reject) => {
      RdbUtils.getStore().query(predicates).then((result) => {
        let commList = new Array<Comment>();
        while (result.goToNextRow()) {
          let bean = new Comment(
            result.getLong(result.getColumnIndex('ID')),
            result.getString(result.getColumnIndex('HEAD')),
            result.getString(result.getColumnIndex('USERNAME')),
            result.getString(result.getColumnIndex('MDESC')),
            result.getLong(result.getColumnIndex('NID')),
            result.getString(result.getColumnIndex('TIME')),
          );
          commList.push(bean);
        }
        resolve(commList);
      }).catch((error) => {
        reject(error)
      })
    })
  }

  static async queryCommentByAccount(account: string): Promise<Array<CommentItem>> {
    let predicates = new relationalStore.RdbPredicates('COMMENT');
    predicates.equalTo("USERNAME", account);

    return new Promise<Array<CommentItem>>((resolve, reject) => {
      RdbUtils.getStore().query(predicates).then(async (result) => {
        let commList = new Array<CommentItem>();
        const promises = [];

        while (result.goToNextRow()) {
          let bean = new Comment(
            result.getLong(result.getColumnIndex('ID')),
            result.getString(result.getColumnIndex('HEAD')),
            result.getString(result.getColumnIndex('USERNAME')),
            result.getString(result.getColumnIndex('MDESC')),
            result.getLong(result.getColumnIndex('NID')),
            result.getString(result.getColumnIndex('TIME')),
          );

          promises.push(
            this.queryNewsByID(bean.nid).then((newsBean: NewsBean) => {
              commList.push(new CommentItem(bean.id, bean.head, bean.username, bean.mdesc, bean.nid, bean.time, newsBean.image));
            })
          );
        }

        Promise.all(promises).then(() => {
          commList.sort((a, b) => new Date(b.time).getTime() - new Date(a.time).getTime());
          resolve(commList);
        }).catch(error => {
          reject(error);
        });

      }).catch((error) => {
        console.error('查询评论失败:', error);
        reject(error);
      })
    })
  }

  static async queryCollectByAccount(account: string): Promise<Array<CollectBean>> {
    let predicates = new relationalStore.RdbPredicates('COLLECT');
    predicates.equalTo("USERNAME", account);

    return new Promise<Array<CollectBean>>((resolve, reject) => {
      RdbUtils.getStore().query(predicates).then((result) => {
        let collList = new Array<CollectBean>();
        while (result.goToNextRow()) {
          let bean = new CollectBean(
            result.getLong(result.getColumnIndex('ID')),
            result.getString(result.getColumnIndex('USERNAME')),
            result.getLong(result.getColumnIndex('NID')),
            result.getString(result.getColumnIndex('TIME')),
          );
          collList.push(bean);
        }
        resolve(collList);
      }).catch((error) => {
        console.error('查询收藏失败:', error);
        reject(error);
      })
    })
  }

  static async checkCollect(account: string, nid: number): Promise<Array<CollectBean>> {
    let predicates = new relationalStore.RdbPredicates('COLLECT');
    predicates.equalTo("USERNAME", account);
    predicates.equalTo("NID", nid);
    return new Promise<Array<CollectBean>>((resolve, reject) => {
      RdbUtils.getStore().query(predicates).then((result) => {
        let collList = new Array<CollectBean>();
        while (result.goToNextRow()) {
          let bean = new CollectBean(
            result.getLong(result.getColumnIndex('ID')),
            result.getString(result.getColumnIndex('USERNAME')),
            result.getLong(result.getColumnIndex('NID')),
            result.getString(result.getColumnIndex('TIME')),
          );
          collList.push(bean);
        }
        resolve(collList);
      }).catch((error) => {
        reject(error)
      })
    })
  }

  //保存缓存
  static saveCache(key: string, value: string) {
    if (this.dataPreferences) {
      this.dataPreferences.put(key, value).then(() => {
        this.dataPreferences.flush();
      });
    }
  }

  // 添加从缓存获取数据的方法
  static async getCache(key: string, defaultValue: string = ''): Promise<string> {
    return new Promise<string>((resolve, reject) => {
      if (!this.dataPreferences) {
        resolve(defaultValue);
        return;
      }
      this.dataPreferences.get(key, defaultValue).then((value) => {
        resolve(value.toString());
      }).catch(() => {
        resolve(defaultValue);
      });
    });
  }

  // 添加重置数据库方法（开发调试用）
  static async resetDatabase(): Promise<void> {
    try {
      console.info("Resetting database...");

      // 删除所有表
      await this.executeSql('DROP TABLE IF EXISTS USERS');
      await this.executeSql('DROP TABLE IF EXISTS NEWS');
      await this.executeSql('DROP TABLE IF EXISTS COMMENT');
      await this.executeSql('DROP TABLE IF EXISTS COLLECT');

      console.info("Database reset completed");

      // 重新创建表
      const USERS_TABLE = 'CREATE TABLE IF NOT EXISTS USERS (ID INTEGER PRIMARY KEY AUTOINCREMENT, ACCOUNT TEXT NOT NULL, PASSWORD TEXT NOT NULL, AVATAR TEXT)';
      const NEWS_TABLE = 'CREATE TABLE IF NOT EXISTS NEWS (ID INTEGER PRIMARY KEY AUTOINCREMENT, IMAGE TEXT NOT NULL,TITLE TEXT NOT NULL,MDESC BLOB,TYPE INTEGER,TIME TEXT NOT NULL)';
      const COMMENT_TABLE = 'CREATE TABLE IF NOT EXISTS COMMENT (ID INTEGER PRIMARY KEY AUTOINCREMENT, HEAD TEXT NOT NULL,USERNAME TEXT NOT NULL,MDESC BLOB,NID INTEGER,TIME TEXT NOT NULL)';
      const COLLECT_TABLE = 'CREATE TABLE IF NOT EXISTS COLLECT (ID INTEGER PRIMARY KEY AUTOINCREMENT, USERNAME TEXT NOT NULL,NID INTEGER,TIME TEXT NOT NULL)';

      await this.executeSql(USERS_TABLE);
      await this.executeSql(NEWS_TABLE);
      await this.executeSql(COMMENT_TABLE);
      await this.executeSql(COLLECT_TABLE);

      console.info("Tables recreated successfully");

    } catch (error) {
      console.error("Database reset failed: " + error);
    }
  }
}