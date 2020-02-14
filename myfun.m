function [state,options,optchanged] = myfun(options,state,flag)

%% 変数の設定
% 動画用オブジェクトをグローバル宣言
global vidObj;
% 永続変数の定義
persistent BestScoreHistry;     % ベストスコアの履歴を格納
persistent ScatterHandle;       % scatterコマンドのハンドル
persistent ScatterHandleBest;   % scatterコマンドのハンドル、ベストスコア用

%% 世代におけるベストスコアの取得、およびインデックスの取得
BestScore = min(state.Score);
BestScoreIndex = find(state.Score == BestScore);
optchanged = false;

%% ベストスコア履歴の格納、およびfigureの上半分に「集団」をプロット
subplot(5,1,[1:3]);
switch flag
    case 'init' % 探索初回における処理内容
        BestScoreHistry(1) = BestScore;
        ScatterHandle = scatter(state.Population(:,1),state.Population(:,2));
        
        % ベストスコアだけ赤丸でプロット
        ScatterHandleBest = scatter(state.Population(BestScoreIndex,1),state.Population(BestScoreIndex,2),'MarkerFaceColor','r');
        
    case 'iter' % 探索初回以降における処理内容
        BestScoreHistry = [BestScoreHistry, BestScore];
        
        % ハンドルを使って各プロットのx,yを更新
        ScatterHandle.XData = state.Population(:,1);
        ScatterHandle.YData = state.Population(:,2);
        ScatterHandleBest.XData = state.Population(BestScoreIndex,1);
        ScatterHandleBest.YData = state.Population(BestScoreIndex,2);
        drawnow
        
    case 'done' % 探索完了時における処理内容
        % ベストスコア履歴をベースワークスペースに渡す
        assignin('base','BestScoreHistry',BestScoreHistry)
end

%% figureの下半分に「世代」のベストスコアをプロット
subplot(5,1,[4:5]);
plot(state.Generation,BestScore,'.r','MarkerSize',10);hold on; grid on;
axis([0 50 0 1]);

%% ビデオオブジェクトにfigureを書き込み
writeVideo(vidObj, getframe(gcf));
end