package com.javatechie.crud.example;

import com.javatechie.crud.example.controller.ProductController;
import com.javatechie.crud.example.entity.Product;
import com.javatechie.crud.example.repository.ProductRepoMemo;
import com.javatechie.crud.example.service.ProductService;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;

public class Tests {
    @Test
    void testRepo(){
        ProductRepoMemo repo = new ProductRepoMemo();
        assert(repo.products.get(0).getColor() == "black");
    }
    @Test
    void testService(){

    }
    @Test
    void testController(){
        /*ProductService service = new ProductService();
        ProductController controller = new ProductController();
        controller.setService(service);
        assert(controller.getService() == service);
        assert(controller.findAllProducts().get(0).getColor() == "black");
        controller.addProduct(new Product());
        assert(controller.findAllProducts().size() == 6);
        assert(controller.findProductById(1).getColor() == "black");
        controller.deleteProduct(2);
        assert(controller.findAllProducts().size() == 5);
        ArrayList<Product> newProds = new ArrayList<>();
        newProds.add(new Product());
        newProds.add(new Product());
        controller.addProducts(newProds);
        assert(controller.findAllProducts().size() == 7);
        Product prod = controller.findProductById(1);
        assert(prod.getId() ==1);
        assert(prod.getShape() == "ds");
        assert(prod.getSupplier() == "test");
        assert(prod.getCount() == 1);
        assert(prod.getQuality() == 1);
        controller.updateProduct(prod);*/
    }
}
