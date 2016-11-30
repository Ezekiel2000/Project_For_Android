package org.kccc.d07_mygallery;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by Ezekiel on 2016. 11. 30..
 */

public class GalleryAdapter extends RecyclerView.Adapter<GalleryAdapter.GalleryViewHolder> {
    private static final String TAG = GalleryAdapter.class.getSimpleName();

    private ArrayList<String> imagePaths = new ArrayList<>();
    private ArrayList<String> imageNames = new ArrayList<>();
    private int measuredWidth;

    /////////////////////////////////
    // 필수구현을 위한 오버라이딩 메서드
    /////////////////////////////////
    @Override
    public GalleryViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View listItem = LayoutInflater
                .from(parent.getContext())
                .inflate(R.layout.list_item, parent, false);

        return new GalleryViewHolder(listItem);
    }

    @Override
    public void onBindViewHolder(GalleryViewHolder holder, int position) {
        holder.path = imagePaths.get(position);
        Bitmap bm = Utils.getBitmap(holder.path, true);
        int width = bm == null ? 0 : bm.getWidth();
        int height = bm == null ? 0 : bm.getHeight();

        holder.ivImage.setImageBitmap(bm);

        // TODO 각 리스트 아이템의 이미지와 텍스트를 채워보세요.
        holder.tvTitle.setText(String.format("%s, (%dx%d)", holder.path, width, height));

        if (measuredWidth == 0) {
            holder.itemView.post(new ImageViewHeightAdjuster(holder, bm));
        } else if (bm != null) {
            double ratio = (double) bm.getHeight() / bm.getWidth();
            holder.ivImage.setMinimumHeight((int) (measuredWidth * ratio));
        }
    }

    @Override
    public int getItemCount() {
        // TODO 리스트 항목의 수를 리턴해주세요.
        return imagePaths.size();
    }

    @Override
    public void onAttachedToRecyclerView(RecyclerView _recyclerView) {
        Utils.collectPicturesInfo(_recyclerView.getContext(), imagePaths, imageNames);
    }

    /////////////////////////////////////
    // 갤러리의 이미지와 정보를 담는 Holder
    /////////////////////////////////////
    class GalleryViewHolder extends RecyclerView.ViewHolder {
        ImageView ivImage;
        TextView tvTitle;
        String path;

        public GalleryViewHolder(View listItem) {
            super(listItem);

            listItem.setOnClickListener(v -> {
                        Context ctx = v.getContext();
                        Intent intent = new Intent(ctx, DetailActivity.class);

                        // TODO DetailActivity 에게 이미지 파일 경로에 대한 정보를 전달하세요.
                        intent.putExtra(DetailActivity.PATH, path);

                        ctx.startActivity(intent);
                    }
            );

            ivImage = (ImageView) listItem.findViewById(R.id.image);

            tvTitle = (TextView) listItem.findViewById(R.id.title);
        }
    }

    ////////////////////////////////////
    // 이미지의 크기에 따라 세로길이를 조절
    ////////////////////////////////////
    class ImageViewHeightAdjuster implements Runnable {

        GalleryViewHolder holder;
        int width;
        int height;

        ImageViewHeightAdjuster(GalleryViewHolder _holder, Bitmap bm) {
            holder = _holder;
            _holder.setIsRecyclable(false);

            width = bm.getWidth();
            height = bm.getHeight();
        }

        @Override
        public void run() {
            measuredWidth = holder.itemView.getWidth();

            double ratio = (double) height / width;
            holder.ivImage.setMinimumHeight((int) (measuredWidth * ratio));
            holder.setIsRecyclable(true);
        }
    }
}
