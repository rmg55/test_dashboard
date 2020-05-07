FROM jupyter/minimal-notebook

#Add Additional Image Labels
LABEL maintainer="Rowan Gaffney <rowan.gaffney@usda.gov>"

USER $NB_UID
#Install Python and R packages in the py_geo and r_geo environmets, respectively.
RUN conda config --set channel_priority strict && \
	conda install -c conda-forge --yes --quiet \
	    'jupyterlab=2.1' \
	    'jupyter-server-proxy=1.3.2' \
	    'xarray=0.15.1' \
	    'rasterio=1.0' \
	    'panel=0.9.5' \
	    'holoviews=1.13.2' \
	    'hvplot=0.5.2' \
	    'bokeh=2.0.1' \
	    'gdal=3.0.4' \
	    'geopandas=0.7' \
	    'dask=2.14' \
	    'datashader=0.10' \
	    'jupyter-panel-proxy=0.1.0' \
	    'fsspec=0.7.2' \
	    'geoviews=1.8.1' \
	    'pandas=1.0.3' \
	    'dask-gateway=0.7' \
	    'dask-labextension' \
	    'gcsfs=0.6' \
	    'zarr=2.4' && \
	conda clean --all -afy && \
	npm cache clean --force && \
  	rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
  	rm -rf /home/$NB_USER/.cache/yarn && \
  	rm -rf /home/$NB_USER/.node-gyp && \
    	fix-permissions /home/$NB_USER && \
    	fix-permissions $CONDA_DIR

RUN conda init bash && exec bash
RUN git clone --branch gae https://github.com/rmg55/test_dashboard.git /rrsru_app


EXPOSE 8080

CMD panel serve \
    --allow-websocket-origin="*" \
    --port=8080 \
    /rrsru_app/test_dashboard/test_dashboard.ipynb
