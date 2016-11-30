package org.kccc.d07_recyclerviewtest;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

/**
 * Created by Ezekiel on 2016. 11. 30..
 */

public class RVAdapter extends RecyclerView.Adapter<RVAdapter.TextViewHolder> {
    private static final String TAG = RVAdapter.class.getSimpleName();
    private static final int LIST_COUNT = 1000;
    private TextView tvStatus;
    private TextViewHolder lastCreateHolder;

    public RVAdapter(TextView _tvStatus) {
        tvStatus = _tvStatus;
    }

    // 필수 구현을 위한 오버라이딩 메서드
    @Override
    public RVAdapter.TextViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View listItem = LayoutInflater
                .from(parent.getContext())
                .inflate(R.layout.list_item, parent, false);

        return lastCreateHolder = new TextViewHolder(listItem);
    }

    @Override
    public int getItemCount() {
        return LIST_COUNT;
    }

    @Override
    public void onBindViewHolder(RVAdapter.TextViewHolder holder, int position) {
        holder.tvHolderNo.setText("holder: " + holder.holderCount);
        holder.tvPosition.setText("position: " + position);
    }

    // 부가 정보를 위한 오버라이딩
    @Override
    public void onViewRecycled(RVAdapter.TextViewHolder holder) {
        tvStatus.setText(String.format("Recycled Golder: %d, Max Holder Count: %d",
                holder.holderCount, lastCreateHolder.holderCount));
    }

    int lastHolderCount;

    class TextViewHolder extends RecyclerView.ViewHolder {

        TextView tvHolderNo;
        TextView tvPosition;

        int holderCount;

        public TextViewHolder(View itemView) {
            super(itemView);

            tvHolderNo = (TextView) itemView.findViewById(R.id.holder);
            tvPosition = (TextView) itemView.findViewById(R.id.position);

            holderCount = lastHolderCount++;
        }

    }
}
