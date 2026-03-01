package com.oceanview.model;

public class RoomType {
    private int typeId;
    private String typeName;
    private double price;
    private String description;
    private String imageUrl;
    private int capacity;

    public RoomType() {
    }

    public RoomType(int typeId, String typeName, double price, String description, String imageUrl, int capacity) {
        this.typeId = typeId;
        this.typeName = typeName;
        this.price = price;
        this.description = description;
        this.imageUrl = imageUrl;
        this.capacity = capacity;
    }

    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }
}
