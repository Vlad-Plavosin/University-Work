import axios from 'axios';
import { AxiosResponse } from 'axios';

jest.mock('axios');

describe('ProductController endpoints', () => {
    it('should add a product', async () => {
      const mockProduct = { id: 1, count: 5, color: 'Red', shape: 'Round', quality: 3, supplier: 'Supplier A' };
      (axios.post as jest.MockedFunction<typeof axios.post>).mockResolvedValueOnce({
        data: mockProduct,
      } as AxiosResponse);
  
      const response = await axios.post('/addProduct', mockProduct);
  
      expect(response.data).toEqual(mockProduct);
      expect(axios.post).toHaveBeenCalledWith('/addProduct', mockProduct);
    });
    describe('ProductController endpoints', () => {
        it('should add multiple products', async () => {
          const mockProducts = [
            { id: 2, count: 5, color: 'Red', shape: 'Round', quality: 3, supplier: 'Supplier A' },
            { id: 3, count: 5, color: 'Red', shape: 'Round', quality: 3, supplier: 'Supplier A' },
          ];
          (axios.post as jest.MockedFunction<typeof axios.post>).mockResolvedValueOnce({
            data: mockProducts,
          } as AxiosResponse);
      
          const response = await axios.post('/addProducts', mockProducts);
      
          expect(response.data).toEqual(mockProducts);
          expect(axios.post).toHaveBeenCalledWith('/addProducts', mockProducts);
        });
      
        it('should retrieve all products', async () => {
          const mockProducts = [
            { id: 1, count: 5, color: 'Red', shape: 'Round', quality: 3, supplier: 'Supplier A' },
            { id: 2, count: 5, color: 'Red', shape: 'Round', quality: 3, supplier: 'Supplier A' },
          ];
          (axios.get as jest.MockedFunction<typeof axios.get>).mockResolvedValueOnce({
            data: mockProducts,
          } as AxiosResponse);
      
          const response = await axios.get('/products');
      
          expect(response.data).toEqual(mockProducts);
          expect(axios.get).toHaveBeenCalledWith('/products');
        });
      
        it('should retrieve a product by ID', async () => {
          const mockProduct = { id: 1, count: 5, color: 'Red', shape: 'Round', quality: 3, supplier: 'Supplier A' };
          (axios.get as jest.MockedFunction<typeof axios.get>).mockResolvedValueOnce({
            data: mockProduct,
          } as AxiosResponse);
      
          const response = await axios.get('/productById/1');
      
          expect(response.data).toEqual(mockProduct);
          expect(axios.get).toHaveBeenCalledWith('/productById/1');
        });
      
        it('should update a product', async () => {
          const mockProduct = { id: 1, count: 5, color: 'Red', shape: 'Round', quality: 3, supplier: 'Supplier A' };
          (axios.put as jest.MockedFunction<typeof axios.put>).mockResolvedValueOnce({
            data: mockProduct,
          } as AxiosResponse);
      
          const response = await axios.put('/update', mockProduct);
      
          expect(response.data).toEqual(mockProduct);
          expect(axios.put).toHaveBeenCalledWith('/update', mockProduct);
        });
      
        it('should delete a product by ID', async () => {
          const mockId = 1;
          const mockResponse = 'Product deleted successfully';
          (axios.delete as jest.MockedFunction<typeof axios.delete>).mockResolvedValueOnce({
            data: mockResponse,
          } as AxiosResponse);
      
          const response = await axios.delete(`/delete/${mockId}`);
      
          expect(response.data).toEqual(mockResponse);
          expect(axios.delete).toHaveBeenCalledWith(`/delete/${mockId}`);
        });
});
});