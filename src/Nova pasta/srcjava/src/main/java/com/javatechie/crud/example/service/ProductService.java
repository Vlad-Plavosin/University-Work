package com.javatechie.crud.example.service;

import com.github.javafaker.Faker;
import com.javatechie.crud.example.entity.Product;
import com.javatechie.crud.example.entity.User;
import com.javatechie.crud.example.repository.ProductRepoMemo;
import com.javatechie.crud.example.repository.ProductRepository;
import com.javatechie.crud.example.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {
    @Autowired
    private ProductRepository repository;
    @Autowired
    private UserRepository userRepository;
    private final SimpMessagingTemplate messagingTemplate;

    private ProductRepoMemo fakeRepo = new ProductRepoMemo();
    Faker faker = new Faker();

    public ProductService(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

//    @Scheduled(fixedRate = 8000)
//    public void timedAddAndPing(){
//        Product newProduct = new Product("round", faker.company().name(),faker.color().name(),faker.number().numberBetween(1,100),faker.number().numberBetween(1,100),157051);
//        repository.save(newProduct);
//        messagingTemplate.convertAndSend("/topic/newPerson", newProduct);
//    }


    public Product saveProduct(Product product) {
        /*int id = 0;
        boolean ok = true;
        while(true){
            for(int i=0;i<fakeRepo.products.size();i++){
                if(fakeRepo.products.get(i).getId() == id)
                    ok = false;

            }
            if(ok == true)
            {
                product.setId(id);
                break;
            }
            ok = true;
            id+=1;
        }
        fakeRepo.products.add(product);
        return product;*/
        return repository.save(product);
    }

    public List<Product> saveProducts(List<Product> products) {
        //fakeRepo.products.addAll(products);
        //return products;
        return repository.saveAll(products);
    }

    public List<Product> getProducts() {
        //return fakeRepo.products;
        return repository.findAll();
    }
    public List<User> getUsers() {
        //return fakeRepo.products;
        return userRepository.findAll();
    }
    public User adduser(User user){
        return userRepository.save(user);
    }

    public Product getProductById(int id) {
        //for (int i =0; i<fakeRepo.products.size();i++)
           // if(fakeRepo.products.get(i).getId() == id)
          //      return fakeRepo.products.get(i);
        //return new Product();
        return repository.findById(id).orElse(null);
    }

    public String deleteProduct(int id) {
        //for (int i =0; i<fakeRepo.products.size();i++)
            //if(fakeRepo.products.get(i).getId() == id)
                //fakeRepo.products.remove(i);
        repository.deleteById(id);
        return "product removed !! " + id;
    }

    public Product updateProduct(Product product) {
        Product existingProduct = repository.findById(product.getId()).orElse(null);
        //for (int i =0; i<fakeRepo.products.size();i++)
            //if(fakeRepo.products.get(i).getId() == product.getId())
                //fakeRepo.products.remove(i);
        existingProduct.setColor(product.getColor());
        existingProduct.setCount(product.getCount());
        existingProduct.setShape(product.getShape());
        existingProduct.setSupplier(product.getSupplier());
        existingProduct.setQuality(product.getQuality());
        return repository.save(existingProduct);
        //System.out.println(product.getId());
        //fakeRepo.products.add(product);
        //return product;
    }


}
