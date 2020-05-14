FROM jupyter/minimal-notebook

#Add Additional Image Labels
LABEL maintainer="Rowan Gaffney <rowan.gaffney@usda.gov>"

SHELL ["/bin/bash", "-c"]
USER root
SHELL ["/bin/bash", "-c"]

USER $NB_UID
#Install Python and R packages in the py_geo and r_geo environmets, respectively.
RUN conda config --set channel_priority strict && \
	conda install -c conda-forge --yes --quiet \
	    'jupyterlab' \
	    'jupyter-server-proxy' \
	    'xarray' \
	    'rasterio' \
	    'panel' \
	    'holoviews' \
	    'hvplot' \
	    'bokeh' \
	    'gdal' \
	    'geopandas' \
	    'dask' \
	    'datashader' \
	    'fsspec' \
	    'geoviews' \
	    'pandas' \
	    'dask-gateway' \
	    'dask-labextension' \
	    'gcsfs' \
	    'zarr' && \
	conda clean --all -afy && \
	npm cache clean --force && \
  	rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
  	rm -rf /home/$NB_USER/.cache/yarn && \
  	rm -rf /home/$NB_USER/.node-gyp && \
    	fix-permissions /home/$NB_USER && \
    	fix-permissions $CONDA_DIR

RUN conda init bash && exec bash
RUN git clone --branch gae https://github.com/rmg55/test_dashboard.git $HOME/rrsru_app


EXPOSE 8080

ENV PROJ_LIB="/opt/conda/share/proj/"

CMD panel serve \
    --allow-websocket-origin="*" \
    --port=8080 \
    $HOME/rrsru_app/test_dashboard.ipynb
