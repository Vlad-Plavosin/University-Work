package com.javatechie.crud.example.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "FRAMES")
public class Frame {

    @Id
    @GeneratedValue
    private int id;
    private String supplier;
    private int cost;

    @ManyToOne
    @JoinColumn(name = "product_id", referencedColumnName = "id")
    private Product product;

    public Frame(String supplier, int cost, Product product) {
        this.supplier = supplier;
        this.cost = cost;
        this.product = product;
    }
}
